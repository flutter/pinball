// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameEvent', () {
    group('RoundLost', () {
      test('can be instantiated', () {
        expect(const RoundLost(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          RoundLost(),
          equals(const RoundLost()),
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

  group('GameStarted', () {
    test('can be instantiated', () {
      expect(const GameStarted(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        GameStarted(),
        equals(const GameStarted()),
      );
    });
  });

  group('GameOver', () {
    test('can be instantiated', () {
      expect(const GameOver(), isNotNull);
    });

    test('supports value equality', () {
      expect(
        GameOver(),
        equals(const GameOver()),
      );
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
