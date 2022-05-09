// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('GoogleWordState', () {
    test('supports value equality', () {
      expect(
        GoogleWordState(
          letterSpriteStates: const {
            0: GoogleLetterSpriteState.dimmed,
            1: GoogleLetterSpriteState.dimmed,
            2: GoogleLetterSpriteState.dimmed,
            3: GoogleLetterSpriteState.dimmed,
            4: GoogleLetterSpriteState.dimmed,
            5: GoogleLetterSpriteState.dimmed,
          },
        ),
        equals(
          GoogleWordState(
            letterSpriteStates: const {
              0: GoogleLetterSpriteState.dimmed,
              1: GoogleLetterSpriteState.dimmed,
              2: GoogleLetterSpriteState.dimmed,
              3: GoogleLetterSpriteState.dimmed,
              4: GoogleLetterSpriteState.dimmed,
              5: GoogleLetterSpriteState.dimmed,
            },
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const GoogleWordState(letterSpriteStates: {}),
          isNotNull,
        );
      });

      test('initial has all dimmed sprite states', () {
        const initialState = GoogleWordState(
          letterSpriteStates: {
            0: GoogleLetterSpriteState.dimmed,
            1: GoogleLetterSpriteState.dimmed,
            2: GoogleLetterSpriteState.dimmed,
            3: GoogleLetterSpriteState.dimmed,
            4: GoogleLetterSpriteState.dimmed,
            5: GoogleLetterSpriteState.dimmed,
          },
        );
        expect(GoogleWordState.initial(), equals(initialState));
      });
    });
  });
}
