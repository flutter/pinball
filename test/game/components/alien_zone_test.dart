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
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('AlienZone', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final alienZone = AlienZone();
        await game.ensureAdd(alienZone);

        expect(game.contains(alienZone), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'two AlienBumper',
        (game) async {
          await game.ready();
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
      late ControlledAlienBumper controlledAlienBumper;
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = MockGameBloc();
      });

      final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
        gameBuilder: EmptyPinballTestGame.new,
        blocBuilder: () => gameBloc,
      );

      flameTester.testGameWidget(
        'activate when deactivated bumper is hit',
        setUp: (game, tester) async {
          controlledAlienBumper = ControlledAlienBumper.a();
          await game.ensureAdd(controlledAlienBumper);

          controlledAlienBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledAlienBumper.controller.isActivated, isTrue);
        },
      );

      flameTester.testGameWidget(
        'deactivate when activated bumper is hit',
        setUp: (game, tester) async {
          controlledAlienBumper = ControlledAlienBumper.a();
          await game.ensureAdd(controlledAlienBumper);

          controlledAlienBumper.controller.hit();
          controlledAlienBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledAlienBumper.controller.isActivated, isFalse);
        },
      );

      flameBlocTester.testGameWidget(
        'add Scored event',
        setUp: (game, tester) async {
          final ball = Ball(baseColor: const Color(0xFF00FFFF));
          final alienZone = AlienZone();
          whenListen(
            gameBloc,
            const Stream<GameState>.empty(),
            initialState: const GameState.initial(),
          );

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
