import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballGameTest.new);

  final gameOverBlocTester = FlameBlocTester<EmptyPinballGameTest, GameBloc>(
    gameBuilder: EmptyPinballGameTest.new,
    blocBuilder: () {
      final bloc = MockGameBloc();
      const state = GameState(
        score: 0,
        balls: 0,
        bonusHistory: [],
        activatedBonusLetters: [],
        activatedDashNests: {},
      );
      whenListen(bloc, Stream.value(state), initialState: state);
      return bloc;
    },
  );

  group('FlipperController', () {
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
              await game.ready();
              await game.add(flipper);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isNegative);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyDownEvents(leftKeys, (event) {
          gameOverBlocTester.testGameWidget(
            'does nothing when is game over',
            setUp: (game, tester) async {
              await game.ensureAdd(flipper);
              controller.onKeyEvent(event, {});
            },
            verify: (game, tester) async {
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
              await game.ready();
              await game.add(flipper);
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
              await game.ready();
              await game.add(flipper);
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
              await game.ready();
              await game.add(flipper);
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
              await game.ready();
              await game.add(flipper);
              controller.onKeyEvent(event, {});

              expect(flipper.body.linearVelocity.y, isPositive);
              expect(flipper.body.linearVelocity.x, isZero);
            },
          );
        });

        testRawKeyDownEvents(rightKeys, (event) {
          gameOverBlocTester.testGameWidget(
            'does nothing when is game over',
            setUp: (game, tester) async {
              await game.ensureAdd(flipper);
              controller.onKeyEvent(event, {});
            },
            verify: (game, tester) async {
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
              await game.ready();
              await game.add(flipper);
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
