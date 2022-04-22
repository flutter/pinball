// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('SparkyTheme', () {
    test('can be instantiated', () {
      final sparkyTheme = SparkyTheme();

      expect(sparkyTheme, isNotNull);
      expect(sparkyTheme.animationPath, isNotNull);
    });

    test('supports value equality', () {
      expect(SparkyTheme(), equals(SparkyTheme()));
    });
  });
}
