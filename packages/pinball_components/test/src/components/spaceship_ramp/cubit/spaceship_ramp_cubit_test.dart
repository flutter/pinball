// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SpaceshipRampCubit', () {
    group('onAscendingBallEntered', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits hits incremented and arrow goes to the next value',
        build: SpaceshipRampCubit.new,
        act: (bloc) => bloc
          ..onAscendingBallEntered()
          ..onAscendingBallEntered()
          ..onAscendingBallEntered(),
        expect: () => [
          isA<SpaceshipRampState>().having((state) => state.hits, 'hits', 1),
          isA<SpaceshipRampState>().having((state) => state.hits, 'hits', 2),
          isA<SpaceshipRampState>().having((state) => state.hits, 'hits', 3),
        ],
      );
    });

    group('onReset', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits state reset to initial values',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState(
          hits: 100,
          lightState: ArrowLightState.active3,
          animationState: ArrowAnimationState.blinking,
        ),
        act: (bloc) => bloc.onReset(),
        expect: () => [
          isA<SpaceshipRampState>()
            ..having((state) => state.hits, 'hits', 0)
            ..having(
              (state) => state.lightState,
              'lightState',
              ArrowLightState.inactive,
            )
            ..having(
              (state) => state.animationState,
              'animationState',
              ArrowAnimationState.idle,
            ),
        ],
      );
    });

    group('onAnimate', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits animationState blinking',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState(
          hits: 100,
          lightState: ArrowLightState.active3,
          animationState: ArrowAnimationState.idle,
        ),
        act: (bloc) => bloc.onAnimate(),
        expect: () => [
          isA<SpaceshipRampState>().having(
            (state) => state.animationState,
            'animationState',
            ArrowAnimationState.blinking,
          ),
        ],
      );
    });

    group('onStop', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits animationState idle and lightState inactive',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState(
          hits: 100,
          lightState: ArrowLightState.active3,
          animationState: ArrowAnimationState.blinking,
        ),
        act: (bloc) => bloc.onStop(),
        expect: () => [
          isA<SpaceshipRampState>()
            ..having(
              (state) => state.lightState,
              'lightState',
              ArrowLightState.inactive,
            )
            ..having(
              (state) => state.animationState,
              'animationState',
              ArrowAnimationState.idle,
            ),
        ],
      );
    });

    group('onBlink', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits next lit state at lightState',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState(
          hits: 100,
          lightState: ArrowLightState.inactive,
          animationState: ArrowAnimationState.blinking,
        ),
        act: (bloc) => bloc
          ..onBlink()
          ..onBlink()
          ..onBlink()
          ..onBlink()
          ..onBlink()
          ..onBlink(),
        expect: () => [
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.active1,
          ),
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.active2,
          ),
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.active3,
          ),
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.active4,
          ),
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.active5,
          ),
          isA<SpaceshipRampState>().having(
            (state) => state.lightState,
            'lightState',
            ArrowLightState.inactive,
          ),
        ],
      );
    });
  });
}
