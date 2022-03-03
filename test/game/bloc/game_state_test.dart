// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameState', () {
    test('supports value equality', () {
      expect(
        GameState(score: 0, balls: 0),
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

    group('isGameOver', () {
      test(
        'is true '
        'when there is only on ball left',
        () {
          const gameState = GameState(
            balls: 1,
            score: 0,
          );
          expect(gameState.isLastBall, isTrue);
        },
      );

      test(
        'is false '
        'when there are more balls left',
        () {
          const gameState = GameState(
            balls: 2,
            score: 0,
          );
          expect(gameState.isLastBall, isFalse);
        },
      );
    });

    group('copyWith', () {
      test(
        'throws AssertionError '
        'when scored is decreased',
        () {
          const gameState = GameState(
            balls: 0,
            score: 2,
          );
          expect(
            () => gameState.copyWith(score: gameState.score - 1),
            throwsAssertionError,
          );
        },
      );

      test(
        'copies correctly '
        'when no arguement specified',
        () {
          const gameState = GameState(
            balls: 0,
            score: 2,
          );
          expect(
            gameState.copyWith(),
            equals(gameState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguements specified',
        () {
          const gameState = GameState(
            score: 2,
            balls: 0,
          );
          final otherGameState = GameState(
            score: gameState.score + 1,
            balls: gameState.balls + 1,
          );
          expect(gameState, isNot(equals(otherGameState)));

          expect(
            gameState.copyWith(
              score: otherGameState.score,
              balls: otherGameState.balls,
            ),
            equals(otherGameState),
          );
        },
      );
    });
  });
}
