import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
    gameBuilder: EmptyPinballTestGame.new,
    blocBuilder: () {
      final bloc = _MockGameBloc();
      const state = GameState(
        score: 0,
        multiplier: 1,
        rounds: 0,
        bonusHistory: [],
      );
      whenListen(bloc, Stream.value(state), initialState: state);
      return bloc;
    },
  );

  group('PlungerController', () {
    group('onKeyEvent', () {
      final downKeys = UnmodifiableListView([
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyS,
      ]);

      late Plunger plunger;
      late PlungerController controller;

      setUp(() {
        plunger = Plunger(compressionDistance: 10);
        controller = PlungerController(plunger);
        plunger.add(controller);
      });

      testRawKeyDownEvents(downKeys, (event) {
        flameTester.test(
          'moves down '
          'when ${event.logicalKey.keyLabel} is pressed',
          (game) async {
            await game.ensureAdd(plunger);
            controller.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isPositive);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyUpEvents(downKeys, (event) {
        flameTester.test(
          'moves up '
          'when ${event.logicalKey.keyLabel} is released '
          'and plunger is below its starting position',
          (game) async {
            await game.ensureAdd(plunger);
            plunger.body.setTransform(Vector2(0, 1), 0);
            controller.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isNegative);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyUpEvents(downKeys, (event) {
        flameTester.test(
          'does not move when ${event.logicalKey.keyLabel} is released '
          'and plunger is in its starting position',
          (game) async {
            await game.ensureAdd(plunger);
            controller.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isZero);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyDownEvents(downKeys, (event) {
        flameBlocTester.testGameWidget(
          'does nothing when is game over',
          setUp: (game, tester) async {
            await game.ensureAdd(plunger);
            controller.onKeyEvent(event, {});
          },
          verify: (game, tester) async {
            expect(plunger.body.linearVelocity.y, isZero);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });
    });
  });
}
