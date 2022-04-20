// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('AlienZone', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final alienZone = AlienZone();
        await game.ensureAdd(alienZone);

        expect(game.contains(alienZone), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'two AlienBumper',
        (game) async {
          final alienZone = AlienZone();
          await game.ensureAdd(alienZone);

          expect(
            alienZone.descendants().whereType<AlienBumper>().length,
            equals(2),
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
        final contactCallback = AlienBumperBallContactCallback();
        final bumper = MockAlienBumper();
        final ball = MockBall();

        when(bumper.animate).thenAnswer((_) async {});

        contactCallback.begin(bumper, ball, MockContact());

        verify(bumper.animate).called(1);
      });

      flameBlocTester.testGameWidget(
        'add Scored event',
        setUp: (game, tester) async {
          final ball = Ball(baseColor: const Color(0xFF00FFFF));
          final alienZone = AlienZone();

          await game.ensureAdd(alienZone);
          await game.ensureAdd(ball);
          game.addContactCallback(BallScorePointsCallback(game));

          final bumpers = alienZone.descendants().whereType<ScorePoints>();

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
}
