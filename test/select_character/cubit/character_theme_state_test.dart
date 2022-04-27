// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';

void main() {
  group('ThemeState', () {
    test('can be instantiated', () {
      expect(const CharacterThemeState.initial(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        CharacterThemeState.initial(),
        equals(const CharacterThemeState.initial()),
      );
    });
  });
}
