// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('RampSensorState', () {
    test('same states are different even though they have same content', () {
      final ball = Ball(baseColor: Colors.red);

      final rampSensorState = RampSensorState(
        type: RampSensorType.door,
        ball: ball,
      );
      final otherRampSensorState = RampSensorState(
        type: RampSensorType.door,
        ball: ball,
      );

      expect(
        rampSensorState,
        isNot(equals(otherRampSensorState)),
      );

      expect(
        rampSensorState.type,
        equals(otherRampSensorState.type),
      );

      expect(
        rampSensorState.ball,
        equals(otherRampSensorState.ball),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          RampSensorState(
            type: RampSensorType.door,
            ball: Ball(baseColor: Colors.red),
          ),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          final rampSensorState = RampSensorState(
            type: RampSensorType.door,
            ball: Ball(baseColor: Colors.red),
          );

          final copiedRampSensorState = rampSensorState.copyWith();

          expect(
            copiedRampSensorState.type,
            equals(rampSensorState.type),
          );

          expect(
            copiedRampSensorState.ball,
            equals(rampSensorState.ball),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          final ball = Ball(baseColor: Colors.blue);
          final rampSensorState = RampSensorState(
            type: RampSensorType.door,
            ball: Ball(baseColor: Colors.red),
          );
          final otherRampSensorState = RampSensorState(
            type: RampSensorType.inside,
            ball: ball,
          );

          final copiedRampSensorState = rampSensorState.copyWith(
            type: RampSensorType.inside,
            ball: ball,
          );

          expect(
            rampSensorState,
            isNot(equals(otherRampSensorState)),
          );

          expect(
            copiedRampSensorState.type,
            equals(otherRampSensorState.type),
          );

          expect(
            copiedRampSensorState.ball,
            equals(otherRampSensorState.ball),
          );
        },
      );
    });
  });
}
