// ignore_for_file: cascade_invocations

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

class _MockPinballGame extends Mock implements PinballGame {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('PlungerController', () {
    late GameBloc gameBloc;

    final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
    );

    late Plunger plunger;
    late PlungerController controller;

    setUp(() {
      gameBloc = _MockGameBloc();
      plunger = ControlledPlunger(compressionDistance: 10);
      controller = PlungerController(plunger);
      plunger.add(controller);
    });

    group('onKeyEvent', () {
      final downKeys = UnmodifiableListView([
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyS,
      ]);

      testRawKeyDownEvents(downKeys, (event) {
        flameTester.test(
          'moves down '
          'when ${event.logicalKey.keyLabel} is pressed',
          (game) async {
            whenListen(
              gameBloc,
              const Stream<GameState>.empty(),
              initialState: const GameState.initial(),
            );

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
            whenListen(
              gameBloc,
              const Stream<GameState>.empty(),
              initialState: const GameState.initial(),
            );

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
            whenListen(
              gameBloc,
              const Stream<GameState>.empty(),
              initialState: const GameState.initial(),
            );

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
            whenListen(
              gameBloc,
              const Stream<GameState>.empty(),
              initialState: const GameState.initial().copyWith(
                status: GameStatus.gameOver,
              ),
            );

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

    flameTester.test(
      'adds the PlungerNoiseBehavior plunger is released',
      (game) async {
        await game.ensureAdd(plunger);
        plunger.body.setTransform(Vector2(0, 1), 0);
        plunger.release();

        await game.ready();
        final count =
            game.descendants().whereType<PlungerNoiseBehavior>().length;
        expect(count, equals(1));
      },
    );
  });

  group('PlungerNoiseBehavior', () {
    late PinballGame game;
    late PinballPlayer player;
    late PlungerNoiseBehavior behavior;

    setUp(() {
      game = _MockPinballGame();
      player = _MockPinballPlayer();

      when(() => game.player).thenReturn(player);
      behavior = PlungerNoiseBehavior();
      behavior.mockGameRef(game);
    });

    test('plays the correct sound on load', () async {
      await behavior.onLoad();

      verify(() => player.play(PinballAudio.launcher)).called(1);
    });

    test('is removed on the first update', () {
      final parent = Component();
      parent.add(behavior);
      parent.update(0); // Run a tick to ensure it is added

      behavior.update(0); // Run its own update where the removal happens

      expect(behavior.shouldRemove, isTrue);
    });
  });
}
