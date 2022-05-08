// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/pinball_components.dart';

void main() {
  group('MultiballState', () {
    test('supports value equality', () {
      expect(
        MultiballState(
          isAnimating: false,
          spriteState: MultiballSpriteState.dimmed,
        ),
        equals(
          MultiballState(
            isAnimating: false,
            spriteState: MultiballSpriteState.dimmed,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          MultiballState(
            isAnimating: false,
            spriteState: MultiballSpriteState.dimmed,
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
            isAnimating: false,
            spriteState: MultiballSpriteState.dimmed,
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
            isAnimating: false,
            spriteState: MultiballSpriteState.dimmed,
          );
          final otherMultiballState = MultiballState(
            isAnimating: true,
            spriteState: MultiballSpriteState.lit,
          );
          expect(multiballState, isNot(equals(otherMultiballState)));

          expect(
            multiballState.copyWith(
              isAnimating: true,
              lightState: MultiballSpriteState.lit,
            ),
            equals(otherMultiballState),
          );
        },
      );
    });
  });
}
