// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('RampSensorCubit', () {
    final ball = Ball(baseColor: Colors.red);

    blocTest<RampSensorCubit, RampSensorState>(
      'onDoor emits [door]',
      build: RampSensorCubit.new,
      act: (bloc) => bloc.onDoor(ball),
      expect: () => [
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.door)
          ..having((state) => state.ball, 'ball', ball),
      ],
    );

    blocTest<RampSensorCubit, RampSensorState>(
      'onDoor twice emits [door, door]',
      build: RampSensorCubit.new,
      act: (bloc) => bloc
        ..onDoor(ball)
        ..onDoor(ball),
      expect: () => [
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.door)
          ..having((state) => state.ball, 'ball', ball),
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.door)
          ..having((state) => state.ball, 'ball', ball),
      ],
    );

    blocTest<RampSensorCubit, RampSensorState>(
      'onInside emits [inside]',
      build: RampSensorCubit.new,
      act: (bloc) => bloc.onInside(ball),
      expect: () => [
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.inside)
          ..having((state) => state.ball, 'ball', ball),
      ],
    );

    blocTest<RampSensorCubit, RampSensorState>(
      'onInside twice emits [inside,inside]',
      build: RampSensorCubit.new,
      act: (bloc) => bloc
        ..onInside(ball)
        ..onInside(ball),
      expect: () => [
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.inside)
          ..having((state) => state.ball, 'ball', ball),
        isA<RampSensorState>()
          ..having((state) => state.type, 'type', RampSensorType.inside)
          ..having((state) => state.ball, 'ball', ball),
      ],
    );
  });
}
