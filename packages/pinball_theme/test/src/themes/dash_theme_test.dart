// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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

    test('ballColor is correct', () {
      expect(DashTheme().ballColor, equals(Colors.blue));
    });

    test('character asset is correct', () {
      expect(
        DashTheme().character,
        equals(Assets.images.dash.character),
      );
    });

    test('background asset is correct', () {
      expect(
        DashTheme().background,
        equals(Assets.images.dash.background),
      );
    });

    test('icon asset is correct', () {
      expect(DashTheme().icon, equals(Assets.images.dash.icon));
    });
  });
}
