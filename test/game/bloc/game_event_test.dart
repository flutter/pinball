// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameEvent', () {
    group('BallLost', () {
      test('can be instantiated', () {
        expect(const BallLost(balls: 1), isNotNull);
      });

      test('supports value equality', () {
        expect(
          BallLost(balls: 1),
          equals(const BallLost(balls: 1)),
        );
        expect(
          BallLost(balls: 2),
          isNot(equals(const BallLost(balls: 1))),
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

    group('MultiplierIncreased', () {
      test('can be instantiated', () {
        expect(const MultiplierIncreased(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          MultiplierIncreased(),
          equals(const MultiplierIncreased()),
        );
      });
    });

    group('MultiplierApplied', () {
      test('can be instantiated', () {
        expect(const MultiplierApplied(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          MultiplierApplied(),
          equals(const MultiplierApplied()),
        );
      });
    });

    group('MultiplierReset', () {
      test('can be instantiated', () {
        expect(const MultiplierReset(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          MultiplierReset(),
          equals(const MultiplierReset()),
        );
      });
    });

    group('BonusActivated', () {
      test('can be instantiated', () {
        expect(const BonusActivated(GameBonus.dashNest), isNotNull);
      });

      test('supports value equality', () {
        expect(
          BonusActivated(GameBonus.googleWord),
          equals(const BonusActivated(GameBonus.googleWord)),
        );
        expect(
          const BonusActivated(GameBonus.googleWord),
          isNot(equals(const BonusActivated(GameBonus.dashNest))),
        );
      });
    });
  });

  group('SparkyTurboChargeActivated', () {
    test('can be instantiated', () {
      expect(const SparkyTurboChargeActivated(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        SparkyTurboChargeActivated(),
        equals(SparkyTurboChargeActivated()),
      );
    });
  });
}
