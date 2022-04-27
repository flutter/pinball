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
          rounds: 3,
          bonusHistory: const [],
        ),
        equals(
          const GameState(
            score: 0,
            multiplier: 1,
            rounds: 3,
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
            rounds: 3,
            bonusHistory: [],
          ),
          isNotNull,
        );
      });
    });

    test(
      'throws AssertionError '
      'when score is negative',
      () {
        expect(
          () => GameState(
            score: -1,
            multiplier: 1,
            rounds: 3,
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
            score: 1,
            multiplier: 0,
            rounds: 3,
            bonusHistory: const [],
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'throws AssertionError '
      'when rounds is negative',
      () {
        expect(
          () => GameState(
            score: 1,
            multiplier: 1,
            rounds: -1,
            bonusHistory: const [],
          ),
          throwsAssertionError,
        );
      },
    );

    group('isGameOver', () {
      test(
          'is true '
          'when no rounds are left', () {
        const gameState = GameState(
          score: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [],
        );
        expect(gameState.isGameOver, isTrue);
      });

      test(
          'is false '
          'when one 1 round left', () {
        const gameState = GameState(
          score: 0,
          multiplier: 1,
          rounds: 1,
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
            score: 2,
            multiplier: 1,
            rounds: 3,
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
            score: 2,
            multiplier: 1,
            rounds: 3,
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
            rounds: 3,
            bonusHistory: [],
          );
          final otherGameState = GameState(
            score: gameState.score + 1,
            multiplier: gameState.multiplier + 1,
            rounds: gameState.rounds + 1,
            bonusHistory: const [GameBonus.googleWord],
          );
          expect(gameState, isNot(equals(otherGameState)));

          expect(
            gameState.copyWith(
              score: otherGameState.score,
              multiplier: otherGameState.multiplier,
              rounds: otherGameState.rounds,
              bonusHistory: otherGameState.bonusHistory,
            ),
            equals(otherGameState),
          );
        },
      );
    });
  });
}
