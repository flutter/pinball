// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameState', () {
    test('supports value equality', () {
      expect(
        GameState(
          score: 0,
          multiplier: 1,
          balls: 0,
          bonusHistory: const [],
        ),
        equals(
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 0,
            bonusHistory: [],
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 0,
            bonusHistory: [],
          ),
          isNotNull,
        );
      });
    });

    test(
      'throws AssertionError '
      'when balls are negative',
      () {
        expect(
          () => GameState(
            balls: -1,
            score: 0,
            multiplier: 1,
            bonusHistory: const [],
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'throws AssertionError '
      'when score is negative',
      () {
        expect(
          () => GameState(
            balls: 0,
            score: -1,
            multiplier: 1,
            bonusHistory: const [],
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'throws AssertionError '
      'when multiplier is less than 1',
      () {
        expect(
          () => GameState(
            balls: 0,
            score: 1,
            multiplier: 0,
            bonusHistory: const [],
          ),
          throwsAssertionError,
        );
      },
    );

    group('isGameOver', () {
      test(
          'is true '
          'when no balls are left', () {
        const gameState = GameState(
          balls: 0,
          score: 0,
          multiplier: 1,
          bonusHistory: [],
        );
        expect(gameState.isGameOver, isTrue);
      });

      test(
          'is false '
          'when one 1 ball left', () {
        const gameState = GameState(
          balls: 1,
          score: 0,
          multiplier: 1,
          bonusHistory: [],
        );
        expect(gameState.isGameOver, isFalse);
      });
    });

    group('copyWith', () {
      test(
        'throws AssertionError '
        'when scored is decreased',
        () {
          const gameState = GameState(
            balls: 0,
            score: 2,
            multiplier: 1,
            bonusHistory: [],
          );
          expect(
            () => gameState.copyWith(score: gameState.score - 1),
            throwsAssertionError,
          );
        },
      );

      test(
        'copies correctly '
        'when no argument specified',
        () {
          const gameState = GameState(
            balls: 0,
            score: 2,
            multiplier: 1,
            bonusHistory: [],
          );
          expect(
            gameState.copyWith(),
            equals(gameState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const gameState = GameState(
            score: 2,
            multiplier: 1,
            balls: 0,
            bonusHistory: [],
          );
          final otherGameState = GameState(
            score: gameState.score + 1,
            multiplier: gameState.multiplier + 1,
            balls: gameState.balls + 1,
            bonusHistory: const [GameBonus.googleWord],
          );
          expect(gameState, isNot(equals(otherGameState)));

          expect(
            gameState.copyWith(
              score: otherGameState.score,
              multiplier: otherGameState.multiplier,
              balls: otherGameState.balls,
              bonusHistory: otherGameState.bonusHistory,
            ),
            equals(otherGameState),
          );
        },
      );
    });
  });
}
