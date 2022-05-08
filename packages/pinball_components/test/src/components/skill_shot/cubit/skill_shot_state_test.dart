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

      test('initial is dimmed and not blinking', () {
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
          const skillShotState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          expect(
            skillShotState.copyWith(),
            equals(skillShotState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const skillShotState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          final otherSkillShotState = SkillShotState(
            spriteState: SkillShotSpriteState.dimmed,
            isBlinking: false,
          );
          expect(skillShotState, isNot(equals(otherSkillShotState)));

          expect(
            skillShotState.copyWith(
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
