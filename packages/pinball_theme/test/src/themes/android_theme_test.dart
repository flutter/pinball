// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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

    test('ballColor is correct', () {
      expect(AndroidTheme().ballColor, equals(Colors.green));
    });

    test('character asset is correct', () {
      expect(
        AndroidTheme().character,
        equals(Assets.images.android.character),
      );
    });

    test('background asset is correct', () {
      expect(
        AndroidTheme().background,
        equals(Assets.images.android.background),
      );
    });

    test('icon asset is correct', () {
      expect(AndroidTheme().icon, equals(Assets.images.android.icon));
    });
  });
}
