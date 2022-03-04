// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('PinballTheme', () {
    const characterTheme = SparkyTheme();

    test('can be instantiated', () {
      expect(PinballTheme(characterTheme: characterTheme), isNotNull);
    });

    test('supports value equality', () {
      expect(
        PinballTheme(characterTheme: characterTheme),
        equals(PinballTheme(characterTheme: characterTheme)),
      );
    });

    test('characterTheme is correct', () {
      expect(
        PinballTheme(characterTheme: characterTheme).characterTheme,
        equals(characterTheme),
      );
    });
  });
}
