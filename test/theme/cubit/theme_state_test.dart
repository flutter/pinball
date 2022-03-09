// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/theme/theme.dart';

void main() {
  group('ThemeState', () {
    test('can be instantiated', () {
      expect(const ThemeState.initial(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        ThemeState.initial(),
        equals(const ThemeState.initial()),
      );
    });
  });
}
