// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/pinball_components.dart';

void main() {
  group('MultiballState', () {
    test('supports value equality', () {
      expect(
        MultiballState(
          animationState: MultiballAnimationState.idle,
          lightState: MultiballLightState.dimmed,
        ),
        equals(
          MultiballState(
            animationState: MultiballAnimationState.idle,
            lightState: MultiballLightState.dimmed,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          MultiballState(
            animationState: MultiballAnimationState.idle,
            lightState: MultiballLightState.dimmed,
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
          final multiballState = MultiballState(
            animationState: MultiballAnimationState.idle,
            lightState: MultiballLightState.dimmed,
          );
          expect(
            multiballState.copyWith(),
            equals(multiballState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          final multiballState = MultiballState(
            animationState: MultiballAnimationState.idle,
            lightState: MultiballLightState.dimmed,
          );
          final otherMultiballState = MultiballState(
            animationState: MultiballAnimationState.blinking,
            lightState: MultiballLightState.lit,
          );
          expect(multiballState, isNot(equals(otherMultiballState)));

          expect(
            multiballState.copyWith(
              animationState: MultiballAnimationState.blinking,
              lightState: MultiballLightState.lit,
            ),
            equals(otherMultiballState),
          );
        },
      );
    });
  });
}
