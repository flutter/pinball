import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _TestGame extends Forge2DGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.flipper.left.keyName,
      Assets.images.flipper.right.keyName,
    ]);
  }

  Future<void> pump(Flipper flipper, {required GameBloc gameBloc}) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [flipper],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('FlipperController', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    group('onKeyEvent', () {
      final leftKeys = UnmodifiableListView([
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.keyA,
      ]);
      final rightKeys = UnmodifiableListView([
        LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.keyD,
      ]);

      group('and Flipper is left', () {
        late Flipper flipper;
        late FlipperController controller;

        setUp(() {
          flipper = Flipper(side: BoardSide.left);
          controller = FlipperController(flipper);
          flipper.add(controller);
        });

        testRawKeyDownEvents(leftKeys, (event) {
          flameTester.test(
            'moves upwards '
            'when ${event.logicalKey.keyLabel} is pressed',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.playing,
                ),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isNegative);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyDownEvents(leftKeys, (event) {
          flameTester.test(
            'does nothing when is game over',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.gameOver,
                ),
              );

              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isZero);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyUpEvents(leftKeys, (event) {
          flameTester.test(
            'moves downwards '
            'when ${event.logicalKey.keyLabel} is released',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.playing,
                ),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isPositive);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyUpEvents(rightKeys, (event) {
          flameTester.test(
            'does nothing '
            'when ${event.logicalKey.keyLabel} is released',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial(),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isZero);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });
      });

      group('and Flipper is right', () {
        late Flipper flipper;
        late FlipperController controller;

        setUp(() {
          flipper = Flipper(side: BoardSide.right);
          controller = FlipperController(flipper);
          flipper.add(controller);
        });

        testRawKeyDownEvents(rightKeys, (event) {
          flameTester.test(
            'moves upwards '
            'when ${event.logicalKey.keyLabel} is pressed',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.playing,
                ),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isNegative);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyUpEvents(rightKeys, (event) {
          flameTester.test(
            'moves downwards '
            'when ${event.logicalKey.keyLabel} is released',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.playing,
                ),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isPositive);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyDownEvents(rightKeys, (event) {
          flameTester.test(
            'does nothing when is game over',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.gameOver,
                ),
              );

              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isZero);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyUpEvents(leftKeys, (event) {
          flameTester.test(
            'does nothing '
            'when ${event.logicalKey.keyLabel} is released',
            (game) async {
              whenListen(
                gameBloc,
                const Stream<GameState>.empty(),
                initialState: const GameState.initial().copyWith(
                  status: GameStatus.playing,
                ),
              );

              await game.ready();
              await game.pump(flipper, gameBloc: gameBloc);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isZero);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });
      });
    });
  });
}
