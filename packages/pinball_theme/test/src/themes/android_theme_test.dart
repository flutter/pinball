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

    test('characterAsset is correct', () {
      expect(AndroidTheme().characterAsset, equals(Assets.images.android));
    });
  });
}
