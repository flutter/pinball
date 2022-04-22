// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('AndroidTheme', () {
    test('can be instantiated', () {
      final androidTheme = AndroidTheme();

      expect(androidTheme, isNotNull);
      expect(androidTheme.animationPath, isNotNull);
    });

    test('supports value equality', () {
      expect(AndroidTheme(), equals(AndroidTheme()));
    });
  });
}
