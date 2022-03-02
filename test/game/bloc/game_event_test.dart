// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameEvent', () {
    group('BallLost', () {
      test('can be instantiated', () {
        expect(const BallLost(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          BallLost(),
          equals(const BallLost()),
        );
      });
    });

    group('Scored', () {
      test('can be instantiated', () {
        expect(const Scored(points: 1), isNotNull);
      });

      test('supports value equality', () {
        expect(
          Scored(points: 1),
          equals(const Scored(points: 1)),
        );
        expect(
          const Scored(points: 1),
          isNot(equals(const Scored(points: 2))),
        );
      });

      test(
          'throws AssertionError '
          'when score is smaller than 1', () {
        expect(() => Scored(points: 0), throwsAssertionError);
      });
    });
  });
}
