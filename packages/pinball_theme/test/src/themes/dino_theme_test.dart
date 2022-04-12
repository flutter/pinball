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

    test('character asset is correct', () {
      expect(
        DinoTheme().character,
        equals(Assets.images.dino.character),
      );
    });

    test('background asset is correct', () {
      expect(
        DinoTheme().background,
        equals(Assets.images.dino.background),
      );
    });

    test('icon asset is correct', () {
      expect(DinoTheme().icon, equals(Assets.images.dino.icon));
    });
  });
}
