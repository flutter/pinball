// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('SparkyTheme', () {
    test('can be instantiated', () {
      expect(SparkyTheme(), isNotNull);
    });

    test('supports value equality', () {
      expect(SparkyTheme(), equals(SparkyTheme()));
    });

    test('ballColor is correct', () {
      expect(SparkyTheme().ballColor, equals(Colors.orange));
    });

    test('character asset is correct', () {
      expect(
        SparkyTheme().character,
        equals(Assets.images.sparky.character),
      );
    });

    test('background asset is correct', () {
      expect(
        SparkyTheme().background,
        equals(Assets.images.sparky.background),
      );
    });

    test('icon asset is correct', () {
      expect(SparkyTheme().icon, equals(Assets.images.sparky.icon));
    });
  });
}
