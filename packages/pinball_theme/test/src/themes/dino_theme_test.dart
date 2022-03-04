// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('DinoTheme', () {
    test('can be instantiated', () {
      expect(DinoTheme(), isNotNull);
    });

    test('supports value equality', () {
      expect(DinoTheme(), equals(DinoTheme()));
    });

    test('ballColor is correct', () {
      expect(DinoTheme().ballColor, equals(Colors.grey));
    });
  });
}
