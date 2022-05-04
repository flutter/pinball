// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SpaceshipRampCubit', () {
    group('onBallInside', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits hits incremented and arrow goes to the next value',
        build: SpaceshipRampCubit.new,
        act: (bloc) => bloc
          ..onBallInside()
          ..onBallInside()
          ..onBallInside(),
        expect: () => [
          SpaceshipRampState(
            hits: 1,
            arrowState: SpaceshipRampArrowSpriteState.active1,
          ),
          SpaceshipRampState(
            hits: 2,
            arrowState: SpaceshipRampArrowSpriteState.active2,
          ),
          SpaceshipRampState(
            hits: 3,
            arrowState: SpaceshipRampArrowSpriteState.active3,
          ),
        ],
      );

      group('arrowState', () {
        blocTest<SpaceshipRampCubit, SpaceshipRampState>(
          'goes to the next value while less than max',
          build: SpaceshipRampCubit.new,
          act: (bloc) => bloc
            ..onBallInside()
            ..onBallInside()
            ..onBallInside()
            ..onBallInside()
            ..onBallInside(),
          expect: () => [
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.active1,
              ),
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.active2,
              ),
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.active3,
              ),
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.active4,
              ),
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.active5,
              ),
          ],
        );

        blocTest<SpaceshipRampCubit, SpaceshipRampState>(
          'goes to the initial value when is max',
          build: SpaceshipRampCubit.new,
          seed: () => SpaceshipRampState(
            hits: 5,
            arrowState: SpaceshipRampArrowSpriteState.active5,
          ),
          act: (bloc) => bloc..onBallInside(),
          expect: () => [
            isA<SpaceshipRampState>()
              ..having(
                (state) => state.arrowState,
                'arrowState',
                SpaceshipRampArrowSpriteState.inactive,
              ),
          ],
        );
      });
    });
  });
}
