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
            activatedDashNests: {},
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
            activatedDashNests: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 5,
            balls: 3,
            activatedDashNests: {},
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
            activatedDashNests: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            balls: 1,
            activatedDashNests: {},
            bonusHistory: [],
          ),
          const GameState(
            score: 0,
            balls: 0,
            activatedDashNests: {},
            bonusHistory: [],
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
            activatedDashNests: {'0'},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 3,
            activatedDashNests: {'0', '1'},
            bonusHistory: [],
          ),
          GameState(
            score: 0,
            balls: 4,
            activatedDashNests: {},
            bonusHistory: [GameBonus.dashNest],
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
              balls: 3,
              activatedDashNests: {},
              bonusHistory: [GameBonus.googleWord],
            ),
            GameState(
              score: 0,
              balls: 3,
              activatedDashNests: {},
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
            balls: 3,
            activatedDashNests: {},
            bonusHistory: [GameBonus.sparkyTurboCharge],
          ),
        ],
      );
    });
  });
}
