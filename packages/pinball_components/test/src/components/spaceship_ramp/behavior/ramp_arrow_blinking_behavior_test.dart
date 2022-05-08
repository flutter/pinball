// ignore_for_file: prefer_const_constructors, cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/ramp_arrow_blinking_behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.multiball.lit.keyName,
      Assets.images.android.ramp.railingForeground.keyName,
      Assets.images.android.ramp.railingBackground.keyName,
      Assets.images.android.ramp.main.keyName,
      Assets.images.android.ramp.arrow.inactive.keyName,
      Assets.images.android.ramp.arrow.active1.keyName,
      Assets.images.android.ramp.arrow.active2.keyName,
      Assets.images.android.ramp.arrow.active3.keyName,
      Assets.images.android.ramp.arrow.active4.keyName,
      Assets.images.android.ramp.arrow.active5.keyName,
    ]);
  }

  Future<void> pump(
    SpaceshipRamp child, {
    required SpaceshipRampCubit spaceshipRampCubit,
  }) async {
    await ensureAdd(
      FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
        value: spaceshipRampCubit,
        children: [
          ZCanvasComponent(children: [child]),
        ],
      ),
    );
  }
}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group(
    'RampArrowBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls onBlink every 0.05 seconds when animation state is animated',
        setUp: (game, tester) async {
          final behavior = RampArrowBlinkingBehavior();
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );

          final spaceshipRamp = SpaceshipRamp.test();
          await game.pump(
            spaceshipRamp,
            spaceshipRampCubit: bloc,
          );
          await spaceshipRamp.add(behavior);

          streamController.add(
            SpaceshipRampState(
              hits: 1,
              animationState: ArrowAnimationState.blinking,
              lightState: ArrowLightState.active1,
            ),
          );
          await tester.pump();
          game.update(0);

          verify(bloc.onBlink).called(1);

          await tester.pump();
          game.update(0.05);

          await streamController.close();
          verify(bloc.onBlink).called(1);
        },
      );

      flameTester.testGameWidget(
        'calls onStop when animation state is stopped',
        setUp: (game, tester) async {
          final behavior = RampArrowBlinkingBehavior();
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final spaceshipRamp = SpaceshipRamp.test();
          await game.pump(
            spaceshipRamp,
            spaceshipRampCubit: bloc,
          );
          await spaceshipRamp.add(behavior);

          streamController.add(
            SpaceshipRampState(
              hits: 1,
              animationState: ArrowAnimationState.blinking,
              lightState: ArrowLightState.active1,
            ),
          );
          await tester.pump();

          streamController.add(
            SpaceshipRampState(
              hits: 1,
              animationState: ArrowAnimationState.idle,
              lightState: ArrowLightState.active1,
            ),
          );

          await streamController.close();
          verify(bloc.onStop).called(1);
        },
      );

      flameTester.testGameWidget(
        'onTick stops when there is no animation',
        setUp: (game, tester) async {
          final behavior = RampArrowBlinkingBehavior();
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final spaceshipRamp = SpaceshipRamp.test();
          await game.pump(
            spaceshipRamp,
            spaceshipRampCubit: bloc,
          );
          await spaceshipRamp.add(behavior);

          streamController.add(
            SpaceshipRampState(
              hits: 1,
              animationState: ArrowAnimationState.idle,
              lightState: ArrowLightState.active1,
            ),
          );
          await tester.pump();

          behavior.onTick();

          expect(behavior.timer.isRunning(), false);
        },
      );

      flameTester.testGameWidget(
        'onTick stops after 10 blinks repetitions',
        setUp: (game, tester) async {
          final behavior = RampArrowBlinkingBehavior();
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final spaceshipRamp = SpaceshipRamp.test();
          await game.pump(
            spaceshipRamp,
            spaceshipRampCubit: bloc,
          );
          await spaceshipRamp.add(behavior);

          streamController.add(
            SpaceshipRampState(
              hits: 1,
              animationState: ArrowAnimationState.blinking,
              lightState: ArrowLightState.inactive,
            ),
          );
          await tester.pump();

          for (var i = 0; i < 10; i++) {
            behavior.onTick();
          }

          expect(behavior.timer.isRunning(), false);
        },
      );
    },
  );
}
