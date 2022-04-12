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

    test('characterAsset is correct', () {
      expect(
        DashTheme().characterAsset,
        equals(Assets.images.dash.character),
      );
    });
  });
}
