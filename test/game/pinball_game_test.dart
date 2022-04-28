// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.androidBumper.a.lit.keyName,
    Assets.images.androidBumper.a.dimmed.keyName,
    Assets.images.androidBumper.b.lit.keyName,
    Assets.images.androidBumper.b.dimmed.keyName,
    Assets.images.backboard.backboardScores.keyName,
    Assets.images.backboard.backboardGameOver.keyName,
    Assets.images.backboard.display.keyName,
    Assets.images.ball.ball.keyName,
    Assets.images.ball.flameEffect.keyName,
    Assets.images.baseboard.left.keyName,
    Assets.images.baseboard.right.keyName,
    Assets.images.boundary.bottom.keyName,
    Assets.images.boundary.outer.keyName,
    Assets.images.boundary.outerBottom.keyName,
    Assets.images.chromeDino.mouth.keyName,
    Assets.images.chromeDino.head.keyName,
    Assets.images.dino.dinoLandTop.keyName,
    Assets.images.dino.dinoLandBottom.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
    Assets.images.googleWord.letter1.keyName,
    Assets.images.googleWord.letter2.keyName,
    Assets.images.googleWord.letter3.keyName,
    Assets.images.googleWord.letter4.keyName,
    Assets.images.googleWord.letter5.keyName,
    Assets.images.googleWord.letter6.keyName,
    Assets.images.kicker.left.keyName,
    Assets.images.kicker.right.keyName,
    Assets.images.launchRamp.ramp.keyName,
    Assets.images.launchRamp.foregroundRailing.keyName,
    Assets.images.launchRamp.backgroundRailing.keyName,
    Assets.images.plunger.plunger.keyName,
    Assets.images.plunger.rocket.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
    Assets.images.slingshot.upper.keyName,
    Assets.images.slingshot.lower.keyName,
    Assets.images.spaceship.saucer.keyName,
    Assets.images.spaceship.bridge.keyName,
    Assets.images.spaceship.ramp.boardOpening.keyName,
    Assets.images.spaceship.ramp.railingForeground.keyName,
    Assets.images.spaceship.ramp.railingBackground.keyName,
    Assets.images.spaceship.ramp.main.keyName,
    Assets.images.spaceship.ramp.arrow.inactive.keyName,
    Assets.images.spaceship.ramp.arrow.active1.keyName,
    Assets.images.spaceship.ramp.arrow.active2.keyName,
    Assets.images.spaceship.ramp.arrow.active3.keyName,
    Assets.images.spaceship.ramp.arrow.active4.keyName,
    Assets.images.spaceship.ramp.arrow.active5.keyName,
    Assets.images.spaceship.rail.main.keyName,
    Assets.images.spaceship.rail.exit.keyName,
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.computer.top.keyName,
    Assets.images.sparky.computer.base.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
  ];

  final flameTester = FlameTester(
    () => PinballTestGame(assets: assets),
  );
  final debugModeFlameTester = FlameTester(
    () => DebugPinballTestGame(assets: assets),
  );

  group('PinballGame', () {
    group('components', () {
      // TODO(alestiago): tests that Blueprints get added once the Blueprint
      // class is removed.
      flameTester.test(
        'has only one Drain',
        (game) async {
          await game.ready();
          expect(
            game.children.whereType<Drain>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one BottomGroup',
        (game) async {
          await game.ready();

          expect(
            game.children.whereType<BottomGroup>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one Plunger',
        (game) async {
          await game.ready();
          expect(
            game.children.whereType<Plunger>().length,
            equals(1),
          );
        },
      );

      flameTester.test('has one FlutterForest', (game) async {
        await game.ready();
        expect(
          game.children.whereType<FlutterForest>().length,
          equals(1),
        );
      });

      flameTester.test(
        'one GoogleWord',
        (game) async {
          await game.ready();
          expect(game.children.whereType<GoogleWord>().length, equals(1));
        },
      );

      group('controller', () {
        group('listenWhen', () {
          flameTester.testGameWidget(
            'listens when all balls are lost and there are more than 0 rounds',
            setUp: (game, tester) async {
              // TODO(ruimiguel): check why testGameWidget doesn't add any ball
              // to the game. Test needs to have no balls, so fortunately works.
              final newState = MockGameState();
              when(() => newState.isGameOver).thenReturn(false);
              game.descendants().whereType<ControlledBall>().forEach(
                    (ball) => ball.controller.lost(),
                  );
              await game.ready();

              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isTrue,
              );
            },
          );

          flameTester.test(
            "doesn't listen when some balls are left",
            (game) async {
              final newState = MockGameState();
              when(() => newState.isGameOver).thenReturn(false);

              expect(
                game.descendants().whereType<ControlledBall>().length,
                greaterThan(0),
              );
              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isFalse,
              );
            },
          );

          flameTester.testGameWidget(
            "doesn't listen when game is over",
            setUp: (game, tester) async {
              // TODO(ruimiguel): check why testGameWidget doesn't add any ball
              // to the game. Test needs to have no balls, so fortunately works.
              final newState = MockGameState();
              when(() => newState.isGameOver).thenReturn(true);
              game.descendants().whereType<ControlledBall>().forEach(
                    (ball) => ball.controller.lost(),
                  );
              await game.ready();

              expect(
                game.descendants().whereType<ControlledBall>().isEmpty,
                isTrue,
              );
              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isFalse,
              );
            },
          );
        });

        group(
          'onNewState',
          () {
            flameTester.test(
              'spawns a ball',
              (game) async {
                final previousBalls =
                    game.descendants().whereType<ControlledBall>().toList();

                game.controller.onNewState(MockGameState());
                await game.ready();
                final currentBalls =
                    game.descendants().whereType<ControlledBall>().toList();

                expect(
                  currentBalls.length,
                  equals(previousBalls.length + 1),
                );
              },
            );
          },
        );
      });
    });
  });

  group('DebugPinballGame', () {
    debugModeFlameTester.test(
      'adds a ball on tap up',
      (game) async {
        final eventPosition = MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.all(10));

        final tapUpEvent = MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

        final previousBalls =
            game.descendants().whereType<ControlledBall>().toList();

        game.onTapUp(tapUpEvent);
        await game.ready();

        expect(
          game.children.whereType<ControlledBall>().length,
          equals(previousBalls.length + 1),
        );
      },
    );
  });
}
