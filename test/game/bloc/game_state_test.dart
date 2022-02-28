import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameState', () {
    test('supports value equality', () {
      expect(
        const GameState(score: 0, balls: 0),
        equals(const GameState(score: 0, balls: 0)),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(const GameState(score: 0, balls: 0), isNotNull);
      });
    });

    test(
      'throws AssertionError '
      'when balls are negative',
      () {
        expect(
          () => GameState(balls: -1, score: 0),
          throwsAssertionError,
        );
      },
    );

    test(
      'throws AssertionError '
      'when score is negative',
      () {
        expect(
          () => GameState(balls: 0, score: -1),
          throwsAssertionError,
        );
      },
    );
  });

  group('isGameOver', () {
    test(
        'is true '
        'when no balls are left', () {
      const gameState = GameState(
        balls: 0,
        score: 0,
      );
      expect(gameState.isGameOver, isTrue);
    });

    test(
        'is false '
        'when one 1 ball left', () {
      const gameState = GameState(
        balls: 1,
        score: 0,
      );
      expect(gameState.isGameOver, isFalse);
    });
  });
}
