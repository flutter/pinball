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

    test('characterAsset is correct', () {
      expect(
        SparkyTheme().characterAsset,
        equals(Assets.images.sparky.character),
      );
    });
  });
}
