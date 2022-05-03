// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SpaceshipRampCubit', () {
    group('onInside', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits hits incremented',
        build: SpaceshipRampCubit.new,
        act: (bloc) => bloc
          ..onInside()
          ..onInside()
          ..onInside(),
        expect: () => [
          SpaceshipRampState(hits: 1),
          SpaceshipRampState(hits: 2),
          SpaceshipRampState(hits: 3),
        ],
      );
    });
  });
}
