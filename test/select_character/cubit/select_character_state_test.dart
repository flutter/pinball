// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';

void main() {
  group('ThemeState', () {
    test('can be instantiated', () {
      expect(const SelectCharacterState.initial(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        SelectCharacterState.initial(),
        equals(const SelectCharacterState.initial()),
      );
    });
  });
}
