import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameBloc', () {
    test('initial state has 3 rounds and empty score', () {
      final gameBloc = GameBloc();
      expect(gameBloc.state.score, equals(0));
      expect(gameBloc.state.rounds, equals(3));
    });

    group('RoundLost', () {
      blocTest<GameBloc, GameState>(
        'decreases number of rounds '
        'when there are already available rounds',
        build: GameBloc.new,
        act: (bloc) {
          bloc.add(const RoundLost());
        },
        expect: () => [
          const GameState(
            score: 0,
            multiplier: 1,
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
          rounds: 2,
          bonusHistory: [],
        ),
        act: (bloc) {
          bloc.add(const RoundLost());
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
          rounds: 2,
          bonusHistory: [],
        ),
        act: (bloc) {
          bloc.add(const RoundLost());
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
          isA<GameState>()
            ..having((state) => state.score, 'score', 2)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 5)
            ..having((state) => state.isGameOver, 'isGameOver', false),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase score "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const RoundLost());
          }
          bloc.add(const Scored(points: 2));
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.rounds, 'rounds', 2)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.rounds, 'rounds', 1)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.rounds, 'rounds', 0)
            ..having((state) => state.isGameOver, 'isGameOver', true),
        ],
      );
    });

    group('MultiplierIncreased', () {
      blocTest<GameBloc, GameState>(
        'increases multiplier '
        'when multiplier is below 6 and game is not over',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const MultiplierIncreased())
          ..add(const MultiplierIncreased()),
        expect: () => [
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.multiplier, 'multiplier', 2)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.multiplier, 'multiplier', 3)
            ..having((state) => state.isGameOver, 'isGameOver', false),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when multiplier is 6 and game is not over',
        build: GameBloc.new,
        seed: () => const GameState(
          score: 0,
          multiplier: 6,
          rounds: 3,
          bonusHistory: [],
        ),
        act: (bloc) => bloc..add(const MultiplierIncreased()),
        expect: () => const <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const RoundLost());
          }
          bloc.add(const MultiplierIncreased());
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having((state) => state.isGameOver, 'isGameOver', false),
          isA<GameState>()
            ..having((state) => state.score, 'score', 0)
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having((state) => state.isGameOver, 'isGameOver', true),
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
          expect: () => [
            isA<GameState>()
              ..having(
                (state) => state.bonusHistory,
                'bonusHistory',
                [GameBonus.googleWord],
              ),
            isA<GameState>()
              ..having(
                (state) => state.bonusHistory,
                'bonusHistory',
                [GameBonus.googleWord, GameBonus.dashNest],
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
        expect: () => [
          isA<GameState>()
            ..having(
              (state) => state.bonusHistory,
              'bonusHistory',
              [GameBonus.sparkyTurboCharge],
            ),
        ],
      );
    });
  });
}
