import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'MultiballCubit',
    () {
      blocTest<MultiballCubit, MultiballState>(
        'onAnimate emits animationState [animate]',
        build: MultiballCubit.new,
        act: (bloc) => bloc.onAnimate(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.animationState,
              'animationState',
              MultiballAnimationState.blinking,
            )
        ],
      );

      blocTest<MultiballCubit, MultiballState>(
        'onStop emits animationState [stopped]',
        build: MultiballCubit.new,
        act: (bloc) => bloc.onStop(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.animationState,
              'animationState',
              MultiballAnimationState.idle,
            )
        ],
      );

      blocTest<MultiballCubit, MultiballState>(
        'onBlink emits lightState [lit, dimmed, lit]',
        build: MultiballCubit.new,
        act: (bloc) => bloc
          ..onBlink()
          ..onBlink()
          ..onBlink(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.lightState,
              'lightState',
              MultiballLightState.lit,
            ),
          isA<MultiballState>()
            ..having(
              (state) => state.lightState,
              'lightState',
              MultiballLightState.dimmed,
            ),
          isA<MultiballState>()
            ..having(
              (state) => state.lightState,
              'lightState',
              MultiballLightState.lit,
            )
        ],
      );
    },
  );
}
