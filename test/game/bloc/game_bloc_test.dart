import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameBloc', () {
    test('initial state has 3 rounds and empty score', () {
      final gameBloc = GameBloc();
      expect(gameBloc.state.roundScore, equals(0));
      expect(gameBloc.state.rounds, equals(3));
    });

    blocTest<GameBloc, GameState>(
      'GameStarted starts the game',
      build: GameBloc.new,
      act: (bloc) => bloc.add(const GameStarted()),
      expect: () => [
        isA<GameState>()
          ..having(
            (state) => state.status,
            'status',
            GameStatus.playing,
          ),
      ],
    );

    blocTest<GameBloc, GameState>(
      'GameOver finishes the game',
      build: GameBloc.new,
      act: (bloc) => bloc.add(const GameOver()),
      expect: () => [
        isA<GameState>()
          ..having(
            (state) => state.status,
            'status',
            GameStatus.gameOver,
          ),
      ],
    );

    group('RoundLost', () {
      blocTest<GameBloc, GameState>(
        'decreases number of rounds '
        'when there are already available rounds',
        build: GameBloc.new,
        act: (bloc) {
          bloc.add(const RoundLost());
        },
        expect: () => [
          isA<GameState>()..having((state) => state.rounds, 'rounds', 2),
        ],
      );

      blocTest<GameBloc, GameState>(
        'sets game over when there are no more rounds',
        build: GameBloc.new,
        act: (bloc) {
          bloc
            ..add(const RoundLost())
            ..add(const RoundLost())
            ..add(const RoundLost());
        },
        expect: () => [
          isA<GameState>()..having((state) => state.rounds, 'rounds', 2),
          isA<GameState>()..having((state) => state.rounds, 'rounds', 1),
          isA<GameState>()
            ..having((state) => state.rounds, 'rounds', 0)
            ..having((state) => state.status, 'status', GameStatus.gameOver),
        ],
      );

      blocTest<GameBloc, GameState>(
        'apply multiplier to roundScore and add it to totalScore '
        'when round is lost',
        build: GameBloc.new,
        seed: () => const GameState(
          totalScore: 10,
          roundScore: 5,
          multiplier: 3,
          rounds: 2,
          bonusHistory: [],
          status: GameStatus.playing,
        ),
        act: (bloc) {
          bloc.add(const RoundLost());
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.totalScore, 'totalScore', 25)
            ..having((state) => state.roundScore, 'roundScore', 0)
        ],
      );

      blocTest<GameBloc, GameState>(
        'resets multiplier when round is lost',
        build: GameBloc.new,
        seed: () => const GameState(
          totalScore: 10,
          roundScore: 5,
          multiplier: 3,
          rounds: 2,
          bonusHistory: [],
          status: GameStatus.playing,
        ),
        act: (bloc) {
          bloc.add(const RoundLost());
        },
        expect: () => [
          isA<GameState>()..having((state) => state.multiplier, 'multiplier', 1)
        ],
      );
    });

    group('Scored', () {
      blocTest<GameBloc, GameState>(
        'increases score when playing',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const GameStarted())
          ..add(const Scored(points: 2))
          ..add(const Scored(points: 3)),
        expect: () => [
          isA<GameState>()
            ..having((state) => state.status, 'status', GameStatus.playing),
          isA<GameState>()
            ..having((state) => state.roundScore, 'roundScore', 2)
            ..having((state) => state.status, 'status', GameStatus.playing),
          isA<GameState>()
            ..having((state) => state.roundScore, 'roundScore', 5)
            ..having((state) => state.status, 'status', GameStatus.playing),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase score when game is over",
        build: GameBloc.new,
        act: (bloc) {
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const RoundLost());
          }
          bloc.add(const Scored(points: 2));
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.roundScore, 'roundScore', 0)
            ..having((state) => state.rounds, 'rounds', 2)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
          isA<GameState>()
            ..having((state) => state.roundScore, 'roundScore', 0)
            ..having((state) => state.rounds, 'rounds', 1)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
          isA<GameState>()
            ..having((state) => state.roundScore, 'roundScore', 0)
            ..having((state) => state.rounds, 'rounds', 0)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
        ],
      );
    });

    group('MultiplierIncreased', () {
      blocTest<GameBloc, GameState>(
        'increases multiplier '
        'when multiplier is below 6 and game is not over',
        build: GameBloc.new,
        act: (bloc) => bloc
          ..add(const GameStarted())
          ..add(const MultiplierIncreased())
          ..add(const MultiplierIncreased()),
        expect: () => [
          isA<GameState>()
            ..having((state) => state.status, 'status', GameStatus.playing),
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 2)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 3)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
        ],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when multiplier is 6 and game is not over',
        build: GameBloc.new,
        seed: () => const GameState(
          totalScore: 10,
          roundScore: 0,
          multiplier: 6,
          rounds: 3,
          bonusHistory: [],
          status: GameStatus.playing,
        ),
        act: (bloc) => bloc..add(const MultiplierIncreased()),
        expect: () => const <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        "doesn't increase multiplier "
        'when game is over',
        build: GameBloc.new,
        act: (bloc) {
          bloc.add(const GameStarted());
          for (var i = 0; i < bloc.state.rounds; i++) {
            bloc.add(const RoundLost());
          }
          bloc.add(const MultiplierIncreased());
        },
        expect: () => [
          isA<GameState>()
            ..having((state) => state.status, 'status', GameStatus.playing),
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
            ),
          isA<GameState>()
            ..having((state) => state.multiplier, 'multiplier', 1)
            ..having(
              (state) => state.status,
              'status',
              GameStatus.gameOver,
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
  });
}
