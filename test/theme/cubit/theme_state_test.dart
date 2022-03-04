// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

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
