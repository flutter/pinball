// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('BallState', () {
    test('supports value equality', () {
      expect(
        BallState(characterTheme: DashTheme()),
        equals(const BallState(characterTheme: DashTheme())),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(const BallState(characterTheme: DashTheme()), isNotNull);
      });
    });
  });
}
