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
  group('PinballGame', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.new);
    final debugModeFlameTester = FlameTester(DebugPinballGameTest.new);

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

      group('controller', () {
        // TODO(alestiago): Write test to be controller agnostic.
        group('listenWhen', () {
          flameTester.test(
            'listens when a ball is lost and no bonus balls',
            (game) async {
              const previousState = GameState(
                score: 0,
                balls: 3,
                bonusBalls: 0,
                activatedBonusLetters: [],
                bonusHistory: [],
                activatedDashNests: {},
              );
              final newState =
                  previousState.copyWith(balls: previousState.balls - 1);

              expect(
                  game.controller.listenWhen(previousState, newState), isTrue);
            },
          );

          flameTester.test(
            "doesn't listen when a ball is lost and has bonus balls",
            (game) async {
              const previousState = GameState(
                score: 0,
                balls: 3,
                bonusBalls: 1,
                activatedBonusLetters: [],
                bonusHistory: [],
                activatedDashNests: {},
              );
              final newState =
                  previousState.copyWith(balls: previousState.balls - 1);

              expect(
                game.controller.listenWhen(previousState, newState),
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
  });
}
