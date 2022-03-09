import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    int bonusLettersCount = 5,
  })  : _bonusLettersCount = bonusLettersCount,
        super(const GameState.initial()) {
    on<BallLost>(_onBallLost);
    on<Scored>(_onScored);
    on<BonusLetterActivated>(_onBonusLetterActivated);
  }

  final int _bonusLettersCount;

  void _onBallLost(BallLost event, Emitter emit) {
    if (state.balls > 0) {
      emit(state.copyWith(balls: state.balls - 1));
    }
  }

  void _onScored(Scored event, Emitter emit) {
    if (!state.isGameOver) {
      emit(state.copyWith(score: state.score + event.points));
    }
  }

  void _onBonusLetterActivated(BonusLetterActivated event, Emitter emit) {
    final updatedList = [...state.bonusLetters, event.letter];

    if (updatedList.length == _bonusLettersCount) {
      emit(
        state.copyWith(
          bonusLetters: [],
          bonusHistory: [
            ...state.bonusHistory,
            GameBonuses.letterSequence,
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          bonusLetters: updatedList,
        ),
      );
    }
  }
}
