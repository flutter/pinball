// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameBloc', () {
    test('initial state has 3 balls and empty score', () {
      final gameBloc = GameBloc();
      expect(gameBloc.state.score, equals(0));
      expect(gameBloc.state.balls, equals(3));
    });

    group('LostBall', () {
      blocTest<GameBloc, GameState>(
        'decreases number of balls',
        build: GameBloc.new,
        act: (bloc) {
          bloc.add(const BallLost());
        },
        expect: () => [
          const GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
        ],
      );
    });

    group('Scored', () {
      blocTest<GameBloc, GameState>(
        'increases score '
        'when game is not over',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const Scored(points: 2))
          ..add(const Scored(points: 3)),
        expect: () => [
          const GameState(
            score: 2,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 5,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase score "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.balls; i++) {
            bloc.add(const BallLost());
          }
          bloc.add(const Scored(points: 2));
        },
        expect: () => [
          const GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            balls: 1,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            balls: 0,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
        ],
      );
    });

    group('BonusLetterActivated', () {
      blocTest<GameBloc, GameState>(
        'adds the letter to the state',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const BonusLetterActivated(0))
          ..add(const BonusLetterActivated(1))
          ..add(const BonusLetterActivated(2)),
        expect: () => const [
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1, 2],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'adds the bonus when the bonusWord is completed',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const BonusLetterActivated(0))
          ..add(const BonusLetterActivated(1))
          ..add(const BonusLetterActivated(2))
          ..add(const BonusLetterActivated(3))
          ..add(const BonusLetterActivated(4))
          ..add(const BonusLetterActivated(5)),
        expect: () => const [
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1, 2],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1, 2, 3],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [0, 1, 2, 3, 4],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [GameBonus.word],
          ),
          GameState(
            score: GameBloc.bonusWordScore,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [GameBonus.word],
          ),
        ],
      );
    });

    group('DashNestActivated', () {
      blocTest<GameBloc, GameState>(
        'adds the bonus when all nests are activated',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const DashNestActivated('0'))
          ..add(const DashNestActivated('1'))
          ..add(const DashNestActivated('2')),
        expect: () => const [
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {'0'},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {'0', '1'},
            activatedSparkyFires: {},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 4,
            activatedBonusLetters: [],
            activatedDashNests: {},
            activatedSparkyFires: {},
            bonusHistory: [GameBonus.dashNest],
          ),
        ],
      );
    });

    group('SparkyFireActivated', () {
      const fireId = '0';

      blocTest<GameBloc, GameState>(
        'adds fireId to collection when activate',
        build: GameBloc.new,
        act: (bloc) => bloc..add(const SparkyFireActivated(fireId)),
        expect: () => [
          isA<GameState>()
            ..having(
              (state) => state.activatedSparkyFires,
              'activatedSparkyFires',
              contains(fireId),
            ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'removes fireId from collection when deactivate',
        build: GameBloc.new,
        seed: () =>
            GameState.initial().copyWith(activatedSparkyFires: {fireId}),
        act: (bloc) => bloc..add(const SparkyFireActivated(fireId)),
        expect: () => [
          isA<GameState>()
            ..having(
              (state) => state.activatedSparkyFires,
              'activatedSparkyFires',
              isNot(contains(fireId)),
            ),
        ],
      );
    });
  });
}
