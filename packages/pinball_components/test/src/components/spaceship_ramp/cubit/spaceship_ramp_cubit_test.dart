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

    group('onProgressed', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits next arrow lightState',
        build: SpaceshipRampCubit.new,
        act: (bloc) => bloc
          ..onProgressed()
          ..onProgressed()
          ..onProgressed()
          ..onProgressed()
          ..onProgressed()
          ..onProgressed(),
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

    group('onReset', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits initial state',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState(
          hits: 100,
          lightState: ArrowLightState.active3,
        ),
        act: (bloc) => bloc.onReset(),
        expect: () => [
          SpaceshipRampState.initial(),
        ],
      );
    });
  });
}
