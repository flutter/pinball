// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  group('SpaceshipRampState', () {
    test('supports value equality', () {
      expect(
        SpaceshipRampState(
          hits: 0,
          lightState: ArrowLightState.inactive,
          animationState: ArrowAnimationState.idle,
        ),
        equals(
          SpaceshipRampState(
            hits: 0,
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          SpaceshipRampState(
            hits: 0,
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
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
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
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
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
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
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
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
          const rampState = SpaceshipRampState(
            hits: 0,
            lightState: ArrowLightState.inactive,
            animationState: ArrowAnimationState.idle,
          );
          final otherRampState = SpaceshipRampState(
            hits: rampState.hits + 1,
            lightState: ArrowLightState.active1,
            animationState: ArrowAnimationState.blinking,
          );
          expect(rampState, isNot(equals(otherRampState)));

          expect(
            rampState.copyWith(
              hits: otherRampState.hits,
              lightState: otherRampState.lightState,
              animationState: otherRampState.animationState,
            ),
            equals(otherRampState),
          );
        },
      );
    });
  });
}
