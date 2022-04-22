// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('DashTheme', () {
    test('can be instantiated', () {
      expect(DashTheme(), isNotNull);
    });

    test('supports value equality', () {
      expect(DashTheme(), equals(DashTheme()));
    });
  });
}
