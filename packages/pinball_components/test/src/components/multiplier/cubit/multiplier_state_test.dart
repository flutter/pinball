// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/pinball_components.dart';

void main() {
  group('MultiplierState', () {
    test('supports value equality', () {
      expect(
        MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.lit,
        ),
        equals(
          MultiplierState(
            value: MultiplierValue.x2,
            spriteState: MultiplierSpriteState.lit,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          MultiplierState(
            value: MultiplierValue.x2,
            spriteState: MultiplierSpriteState.lit,
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
          const multiplierState = MultiplierState(
            value: MultiplierValue.x2,
            spriteState: MultiplierSpriteState.lit,
          );
          expect(
            multiplierState.copyWith(),
            equals(multiplierState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const multiplierState = MultiplierState(
            value: MultiplierValue.x2,
            spriteState: MultiplierSpriteState.lit,
          );
          final otherMultiplierState = MultiplierState(
            value: MultiplierValue.x2,
            spriteState: MultiplierSpriteState.dimmed,
          );
          expect(multiplierState, isNot(equals(otherMultiplierState)));

          expect(
            multiplierState.copyWith(
              spriteState: MultiplierSpriteState.dimmed,
            ),
            equals(otherMultiplierState),
          );
        },
      );
    });
  });
}
