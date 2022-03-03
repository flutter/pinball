// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/character_themes/character_themes.dart';

void main() {
  group('ThemeState', () {
    test('can be instantiated', () {
      expect(const ThemeState(DashTheme()), isNotNull);
    });

    test('supports value equality', () {
      expect(
        ThemeState(DashTheme()),
        equals(const ThemeState(DashTheme())),
      );
    });
  });
}
