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
          SpaceshipRampState(hits: 1),
          SpaceshipRampState(hits: 2),
          SpaceshipRampState(hits: 3),
        ],
      );
    });
  });
}
