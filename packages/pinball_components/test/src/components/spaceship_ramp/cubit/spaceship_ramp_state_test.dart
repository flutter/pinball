// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  group('SpaceshipRampState', () {
    test('supports value equality', () {
      expect(
        SpaceshipRampState(
          hits: 0,
          balls: const {},
          shot: false,
          status: SpaceshipRampStatus.withoutBonus,
        ),
        equals(
          SpaceshipRampState(
            hits: 0,
            balls: const {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          SpaceshipRampState(
            hits: 0,
            balls: const {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          ),
          isNotNull,
        );
      });
    });

    test(
      'throws AssertionError '
      'when hits is negative',
      () {
        expect(
          () => SpaceshipRampState(
            hits: -1,
            balls: const {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          ),
          throwsAssertionError,
        );
      },
    );

    group('copyWith', () {
      test(
        'throws AssertionError '
        'when hits is decreased',
        () {
          const rampState = SpaceshipRampState(
            hits: 0,
            balls: {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          );
          expect(
            () => rampState.copyWith(hits: rampState.hits - 1),
            throwsAssertionError,
          );
        },
      );

      test(
        'copies correctly '
        'when no argument specified',
        () {
          const rampState = SpaceshipRampState(
            hits: 0,
            balls: {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          );
          expect(
            rampState.copyWith(),
            equals(rampState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          final ball = Ball(baseColor: Colors.black);

          const rampState = SpaceshipRampState(
            hits: 0,
            balls: {},
            shot: false,
            status: SpaceshipRampStatus.withoutBonus,
          );
          final otherRampState = SpaceshipRampState(
            hits: rampState.hits + 1,
            balls: {ball},
            shot: true,
            status: SpaceshipRampStatus.withBonus,
          );
          expect(rampState, isNot(equals(otherRampState)));

          expect(
            rampState.copyWith(
              hits: rampState.hits + 1,
              balls: {ball},
              shot: true,
              status: SpaceshipRampStatus.withBonus,
            ),
            equals(otherRampState),
          );
        },
      );
    });
  });
}
