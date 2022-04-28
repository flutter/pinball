// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('AndroidTheme', () {
    test('can be instantiated', () {
      expect(AndroidTheme(), isNotNull);
    });

    test('supports value equality', () {
      expect(AndroidTheme(), equals(AndroidTheme()));
    });
  });
}
