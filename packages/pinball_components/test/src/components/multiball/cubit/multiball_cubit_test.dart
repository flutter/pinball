import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'MultiballCubit',
    () {
      blocTest<MultiballCubit, MultiballState>(
        'onAnimate emits isAnimating true',
        build: MultiballCubit.new,
        act: (bloc) => bloc.onAnimate(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.isAnimating,
              'isAnimating',
              true,
            )
        ],
      );

      blocTest<MultiballCubit, MultiballState>(
        'onStop emits isAnimating false',
        build: MultiballCubit.new,
        act: (bloc) => bloc.onStop(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.isAnimating,
              'isAnimating',
              false,
            )
        ],
      );

      blocTest<MultiballCubit, MultiballState>(
        'onBlinked emits lightState [lit, dimmed, lit]',
        build: MultiballCubit.new,
        act: (bloc) => bloc
          ..onBlinked()
          ..onBlinked()
          ..onBlinked(),
        expect: () => [
          isA<MultiballState>()
            ..having(
              (state) => state.spriteState,
              'lightState',
              MultiballSpriteState.lit,
            ),
          isA<MultiballState>()
            ..having(
              (state) => state.spriteState,
              'lightState',
              MultiballSpriteState.dimmed,
            ),
          isA<MultiballState>()
            ..having(
              (state) => state.spriteState,
              'lightState',
              MultiballSpriteState.lit,
            )
        ],
      );
    },
  );
}
