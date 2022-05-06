// ignore_for_file: cascade_invocations

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

class _TestGame extends Forge2DGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(Assets.images.plunger.plunger.keyName);
  }

  Future<void> pump(
    Plunger child, {
    GameBloc? gameBloc,
    PinballPlayer? pinballPlayer,
  }) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc ?? GameBloc()
          ..add(const GameStarted()),
        children: [
          FlameProvider<PinballPlayer>.value(
            pinballPlayer ?? _MockPinballPlayer(),
            children: [child],
          )
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('PlungerController', () {
    late GameBloc gameBloc;

    final flameBlocTester = FlameTester(_TestGame.new);

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
            await game.pump(plunger);
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
            await game.pump(plunger);
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
            await game.pump(plunger);
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

            await game.pump(plunger, gameBloc: gameBloc);
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
        await game.pump(plunger);
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
    late PinballPlayer player;

    setUp(() {
      player = _MockPinballPlayer();
    });

    flameTester.test('plays the correct sound on load', (game) async {
      final parent = ControlledPlunger(compressionDistance: 10);
      await game.pump(parent, pinballPlayer: player);
      await parent.ensureAdd(PlungerNoiseBehavior());
      verify(() => player.play(PinballAudio.launcher)).called(1);
    });

    test('is removed on the first update', () {
      final parent = Component();
      final behavior = PlungerNoiseBehavior();
      parent.add(behavior);
      parent.update(0); // Run a tick to ensure it is added

      behavior.update(0); // Run its own update where the removal happens

      expect(behavior.shouldRemove, isTrue);
    });
  });
}
