// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/character_themes/character_themes.dart';

void main() {
  group('AndroidTheme', () {
    test('can be instantiated', () {
      expect(AndroidTheme(), isNotNull);
    });

    test('supports value equality', () {
      expect(AndroidTheme(), equals(AndroidTheme()));
    });

    test('ballColor is correct', () {
      expect(AndroidTheme().ballColor, equals(Colors.green));
    });
  });
}
