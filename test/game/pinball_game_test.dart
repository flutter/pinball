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
    Assets.images.ball.ball.keyName,
    Assets.images.ball.flameEffect.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
    Assets.images.baseboard.left.keyName,
    Assets.images.baseboard.right.keyName,
    Assets.images.kicker.left.keyName,
    Assets.images.kicker.right.keyName,
    Assets.images.slingshot.upper.keyName,
    Assets.images.slingshot.lower.keyName,
    Assets.images.launchRamp.ramp.keyName,
    Assets.images.launchRamp.foregroundRailing.keyName,
    Assets.images.launchRamp.backgroundRailing.keyName,
    Assets.images.dino.dinoLandTop.keyName,
    Assets.images.dino.dinoLandBottom.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.plunger.plunger.keyName,
    Assets.images.plunger.rocket.keyName,
    Assets.images.boundary.bottom.keyName,
    Assets.images.boundary.outer.keyName,
    Assets.images.boundary.outerBottom.keyName,
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
    Assets.images.spaceship.rail.foreground.keyName,
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
    Assets.images.chromeDino.mouth.keyName,
    Assets.images.chromeDino.head.keyName,
    Assets.images.sparky.computer.top.keyName,
    Assets.images.sparky.computer.base.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
    Assets.images.backboard.backboardScores.keyName,
    Assets.images.backboard.backboardGameOver.keyName,
    Assets.images.googleWord.letter1.keyName,
    Assets.images.googleWord.letter2.keyName,
    Assets.images.googleWord.letter3.keyName,
    Assets.images.googleWord.letter4.keyName,
    Assets.images.googleWord.letter5.keyName,
    Assets.images.googleWord.letter6.keyName,
    Assets.images.backboard.display.keyName,
  ];

  final flameTester = FlameTester(() => PinballTestGame(assets));
  final debugModeFlameTester = FlameTester(() => DebugPinballTestGame(assets));
  late GameBloc gameBloc;

  setUp(() {
    gameBloc = GameBloc();
  });

  final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
    gameBuilder: EmptyPinballTestGame.new,
    blocBuilder: () => gameBloc,
    // assets: assets,
  );

  group('PinballGame', () {
    // TODO(alestiago): test if [PinballGame] registers
    // [BallScorePointsCallback] once the following issue is resolved:
    // https://github.com/flame-engine/flame/issues/1416
    group('components', () {
      flameTester.testGameWidget(
        'has only one BottomWall',
        setUp: (game, tester) async {
          await game.ensureAdd(BottomWall());
          await game.ready();
          expect(
            game.children.whereType<BottomWall>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one Plunger',
        setUp: (game, tester) async {
          await game.ready();
          expect(
            game.children.whereType<Plunger>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has one Board',
        setUp: (game, tester) async {
          await game.ready();
          expect(
            game.children.whereType<Board>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'one AlienZone',
        setUp: (game, tester) async {
          await game.ready();
          expect(game.children.whereType<AlienZone>().length, equals(1));
        },
      );

      group('controller', () {
        // TODO(alestiago): Write test to be controller agnostic.
        group('listenWhen', () {
          flameTester.testGameWidget(
            'listens when all balls are lost and there are more than 0 rounds',
            setUp: (game, tester) async {
              final newState = MockGameState();
              when(() => newState.balls).thenReturn(0);
              when(() => newState.rounds).thenReturn(2);

              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isTrue,
              );
            },
          );

          flameTester.testGameWidget(
            "doesn't listen when some balls are left",
            setUp: (game, tester) async {
              final newState = MockGameState();
              when(() => newState.balls).thenReturn(1);
              when(() => newState.rounds).thenReturn(2);

              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isFalse,
              );
            },
          );

          flameTester.testGameWidget(
            "doesn't listen when no balls left",
            setUp: (game, tester) async {
              final newState = MockGameState();
              when(() => newState.balls).thenReturn(1);
              when(() => newState.rounds).thenReturn(0);

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
            flameTester.testGameWidget(
              'spawns a ball',
              setUp: (game, tester) async {
                await game.ready();

                final previousBalls =
                    game.descendants().whereType<Ball>().toList();

                game.controller.onNewState(MockGameState());
                await game.ready();
                final currentBalls =
                    game.descendants().whereType<Ball>().toList();

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
    debugModeFlameTester.testGameWidget(
      'adds a ball on tap up',
      setUp: (game, tester) async {
        await game.ready();
        await tester.pump();

        final eventPosition = MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.all(10));

        final tapUpEvent = MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

        final previousBalls = game.descendants().whereType<Ball>().toList();

        game.onTapUp(tapUpEvent);
        await game.ready();

        expect(
          game.children.whereType<Ball>().length,
          equals(previousBalls.length + 1),
        );
      },
    );
  });
}
