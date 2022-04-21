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
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
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
  ];
  final flameTester = FlameTester(() => PinballTestGame(assets));
  final debugModeFlameTester = FlameTester(() => DebugPinballTestGame(assets));

  group('PinballGame', () {
    // TODO(alestiago): test if [PinballGame] registers
    // [BallScorePointsCallback] once the following issue is resolved:
    // https://github.com/flame-engine/flame/issues/1416
    group('components', () {
      flameTester.test(
        'has three Walls',
        (game) async {
          await game.ready();
          final walls = game.children.where(
            (component) => component is Wall && component is! BottomWall,
          );
          expect(walls.length, 3);
        },
      );

      flameTester.test(
        'has only one BottomWall',
        (game) async {
          await game.ready();

          expect(
            game.children.whereType<BottomWall>().length,
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

      flameTester.test('has one Board', (game) async {
        await game.ready();
        expect(
          game.children.whereType<Board>().length,
          equals(1),
        );
      });

      flameTester.test(
        'one SparkyFireZone',
        (game) async {
          await game.ready();
          expect(game.children.whereType<SparkyFireZone>().length, equals(1));
        },
      );

      flameTester.test(
        'one AlienZone',
        (game) async {
          await game.ready();
          expect(game.children.whereType<AlienZone>().length, equals(1));
        },
      );

      group('controller', () {
        // TODO(alestiago): Write test to be controller agnostic.
        group('listenWhen', () {
          late GameBloc gameBloc;

          setUp(() {
            gameBloc = GameBloc();
          });

          final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
            gameBuilder: EmptyPinballTestGame.new,
            blocBuilder: () => gameBloc,
            // assets: assets,
          );

          flameBlocTester.testGameWidget(
            'listens when all balls are lost and there are more than 0 balls',
            setUp: (game, tester) async {
              final newState = MockGameState();
              when(() => newState.balls).thenReturn(2);
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
              when(() => newState.balls).thenReturn(1);

              expect(
                game.descendants().whereType<Ball>().length,
                greaterThan(0),
              );
              expect(
                game.controller.listenWhen(MockGameState(), newState),
                isFalse,
              );
            },
          );

          flameBlocTester.test(
            "doesn't listen when no balls left",
            (game) async {
              final newState = MockGameState();
              when(() => newState.balls).thenReturn(0);

              game.descendants().whereType<ControlledBall>().forEach(
                    (ball) => ball.controller.lost(),
                  );
              await game.ready();

              expect(
                game.descendants().whereType<Ball>().isEmpty,
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
    debugModeFlameTester.test('adds a ball on tap up', (game) async {
      await game.ready();

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
    });

    group('controller', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = GameBloc();
      });

      final debugModeFlameBlocTester =
          FlameBlocTester<DebugPinballGame, GameBloc>(
        gameBuilder: DebugPinballTestGame.new,
        blocBuilder: () => gameBloc,
        assets: assets,
      );

      debugModeFlameBlocTester.testGameWidget(
        'ignores debug balls',
        setUp: (game, tester) async {
          final newState = MockGameState();
          when(() => newState.balls).thenReturn(1);

          await game.ready();
          game.children.removeWhere((component) => component is Ball);
          await game.ready();
          await game.ensureAdd(ControlledBall.debug());

          expect(
            game.controller.listenWhen(MockGameState(), newState),
            isTrue,
          );
        },
      );
    });
  });
}
