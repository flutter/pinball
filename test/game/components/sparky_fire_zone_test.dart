// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
    Assets.images.sparky.animatronic.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('SparkyFireZone', () {
    flameTester.test('loads correctly', (game) async {
      final sparkyFireZone = SparkyFireZone();
      await game.ensureAdd(sparkyFireZone);
    });

    group('loads', () {
      flameTester.test(
        'a SparkyComputer',
        (game) async {
          expect(
            SparkyFireZone().blueprints.whereType<SparkyComputer>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a SparkyAnimatronic',
        (game) async {
          final sparkyFireZone = SparkyFireZone();
          await game.addFromBlueprint(sparkyFireZone);
          await game.ready();

          expect(
            game.descendants().whereType<SparkyAnimatronic>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'three SparkyBumper',
        (game) async {
          final sparkyFireZone = SparkyFireZone();
          await game.addFromBlueprint(sparkyFireZone);
          await game.ready();

          expect(
            game.descendants().whereType<SparkyBumper>().length,
            equals(3),
          );
        },
      );
    });

    group('bumpers', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
        gameBuilder: EmptyPinballTestGame.new,
        blocBuilder: () => gameBloc,
        assets: assets,
      );

      flameTester.test('call animate on contact', (game) async {
        final contactCallback = SparkyBumperBallContactCallback();
        final bumper = MockSparkyBumper();
        final ball = MockBall();

        when(bumper.animate).thenAnswer((_) async {});

        contactCallback.begin(bumper, ball, MockContact());

        verify(bumper.animate).called(1);
      });

      flameBlocTester.testGameWidget(
        'add Scored event',
        setUp: (game, tester) async {
          final ball = Ball(baseColor: const Color(0xFF00FFFF));
          final sparkyFireZone = SparkyFireZone();
          await game.addFromBlueprint(sparkyFireZone);
          await game.ensureAdd(ball);
          game.addContactCallback(BallScorePointsCallback(game));

          final bumpers = sparkyFireZone.components.whereType<ScorePoints>();

          for (final bumper in bumpers) {
            beginContact(game, bumper, ball);
            verify(
              () => gameBloc.add(
                Scored(points: bumper.points),
              ),
            ).called(1);
          }
        },
      );
    });
  });

  group('SparkyTurboChargeSensorBallContactCallback', () {
    flameTester.test('calls turboCharge', (game) async {
      final callback = SparkyComputerSensorBallContactCallback();
      final ball = MockControlledBall();
      final controller = MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(() => ball.gameRef).thenReturn(game);
      when(controller.turboCharge).thenAnswer((_) async {});

      callback.begin(MockSparkyComputerSensor(), ball, MockContact());

      verify(() => ball.controller.turboCharge()).called(1);
    });

    flameTester.test('plays SparkyAnimatronic', (game) async {
      final callback = SparkyComputerSensorBallContactCallback();
      final ball = MockControlledBall();
      final controller = MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(() => ball.gameRef).thenReturn(game);
      when(controller.turboCharge).thenAnswer((_) async {});

      final sparkyFireZone = SparkyFireZone();
      await game.addFromBlueprint(sparkyFireZone);
      await game.ready();

      final sparkyAnimatronic =
          sparkyFireZone.components.whereType<SparkyAnimatronic>().single;

      expect(sparkyAnimatronic.playing, isFalse);
      callback.begin(MockSparkyComputerSensor(), ball, MockContact());

      expect(sparkyAnimatronic.playing, isTrue);
    });
  });
}
