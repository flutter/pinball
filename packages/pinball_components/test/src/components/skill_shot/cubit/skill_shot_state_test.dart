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
          const skillshotState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          expect(
            skillshotState.copyWith(),
            equals(skillshotState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const skillshotState = SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          );
          final otherSkillShotState = SkillShotState(
            spriteState: SkillShotSpriteState.dimmed,
            isBlinking: false,
          );
          expect(skillshotState, isNot(equals(otherSkillShotState)));

          expect(
            skillshotState.copyWith(
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
