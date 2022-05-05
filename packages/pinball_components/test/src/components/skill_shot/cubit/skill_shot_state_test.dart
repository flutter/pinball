// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SkillShotState', () {
    test('supports value equality', () {
      expect(
        SkillShotState(
          spriteState: SkillShotSpriteState.lit,
          isBlinking: true,
        ),
        equals(
          const SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          ),
          isNotNull,
        );
      });

      test('initial is idle with mouth closed', () {
        const initialState = SkillShotState(
          spriteState: SkillShotSpriteState.dimmed,
          isBlinking: false,
        );
        expect(SkillShotState.initial(), equals(initialState));
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const chromeDinoState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          expect(
            chromeDinoState.copyWith(),
            equals(chromeDinoState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const chromeDinoState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          final otherSkillShotState = SkillShotState(
            spriteState: SkillShotSpriteState.dimmed,
            isBlinking: false,
          );
          expect(chromeDinoState, isNot(equals(otherSkillShotState)));

          expect(
            chromeDinoState.copyWith(
              spriteState: SkillShotSpriteState.dimmed,
              isBlinking: false,
            ),
            equals(otherSkillShotState),
          );
        },
      );
    });
  });
}
