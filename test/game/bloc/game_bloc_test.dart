import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameBloc', () {
    test('initial state has 3 rounds, 1 ball and empty score', () {
      final gameBloc = GameBloc();
      expect(gameBloc.state.score, equals(0));
      expect(gameBloc.state.balls, equals(1));
      expect(gameBloc.state.rounds, equals(3));
    });

    group('BallLost', () {
      blocTest<GameBloc, GameState>(
        'decreases number of balls',
        build: GameBloc.new,
        act: (bloc) {
          bloc.add(const BallLost(balls: 0));
        },
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 2,
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'apply multiplier to score '
        'when round is lost',
        build: GameBloc.new,
        seed: () => const GameState(
          score: 5,
          multiplier: 3,
          balls: 1,
          rounds: 2,
          bonusHistory: [],
        ),
        act: (bloc) {
          bloc.add(const BallLost(balls: 0));
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.score, 'score', 15)
            ..having((state) => state.rounds, 'rounds', 1),
        ],
      );

      blocTest<GameBloc, GameState>(
        'resets multiplier '
        'when round is lost',
        build: GameBloc.new,
        seed: () => const GameState(
          score: 5,
          multiplier: 3,
          balls: 1,
          rounds: 2,
          bonusHistory: [],
        ),
        act: (bloc) {
          bloc.add(const BallLost(balls: 0));
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having((state) => state.rounds, 'rounds', 1),
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
            multiplier: 1,
            balls: 1,
            rounds: 3,
            bonusHistory: [],
          ),
          const GameState(
            score: 5,
            multiplier: 1,
            balls: 1,
            rounds: 3,
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase score "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const BallLost(balls: 0));
          }
          bloc.add(const Scored(points: 2));
        },
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 2,
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 1,
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 0,
            bonusHistory: [],
          ),
        ],
      );
    });

    group('MultiplierIncreased', () {
      blocTest<GameBloc, GameState>(
        'increases multiplier '
        'when game is not over',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const MultiplierIncreased())
          ..add(const MultiplierIncreased()),
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 2,
            balls: 1,
            rounds: 3,
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            multiplier: 3,
            balls: 1,
            rounds: 3,
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when multiplier is 6 and game is not over',
        build: GameBloc.new,
        seed: () => const GameState(
          score: 0,
          multiplier: 5,
          balls: 1,
          rounds: 3,
          bonusHistory: [],
        ),
        act: (bloc) => bloc
          ..add(const MultiplierIncreased())
          ..add(const MultiplierIncreased()),
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 6,
            balls: 1,
            rounds: 3,
            bonusHistory: [],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const BallLost(balls: 0));
          }
          bloc.add(const MultiplierIncreased());
        },
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 2,
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 1,
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 0,
            bonusHistory: [],
          ),
        ],
      );
    });

    group(
      'BonusActivated',
      () {
        blocTest<GameBloc, GameState>(
          'adds bonus to history',
          build: GameBloc.new,
          act: (bloc) => bloc
            ..add(const BonusActivated(GameBonus.googleWord))
            ..add(const BonusActivated(GameBonus.dashNest)),
          expect: () => const [
            GameState(
              score: 0,
              multiplier: 1,
              balls: 1,
              rounds: 3,
              bonusHistory: [GameBonus.googleWord],
            ),
            GameState(
              score: 0,
              multiplier: 1,
              balls: 1,
              rounds: 3,
              bonusHistory: [GameBonus.googleWord, GameBonus.dashNest],
            ),
          ],
        );
      },
    );

    group('SparkyTurboChargeActivated', () {
      blocTest<GameBloc, GameState>(
        'adds game bonus',
        build: GameBloc.new,
        act: (bloc) => bloc..add(const SparkyTurboChargeActivated()),
        expect: () => const [
          GameState(
            score: 0,
            multiplier: 1,
            balls: 1,
            rounds: 3,
            bonusHistory: [GameBonus.sparkyTurboCharge],
          ),
        ],
      );
    });
  });
}
