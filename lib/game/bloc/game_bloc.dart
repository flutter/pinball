// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    int bonusLettersLength = bonusWord.length,
  })  : _bonusLettersLength = bonusLettersLength,
        super(const GameState.initial()) {
    on<BallLost>(_onBallLost);
    on<Scored>(_onScored);
    on<BonusLetterActivated>(_onBonusLetterActivated);
  }

  final int _bonusLettersLength;
  static const bonusWord = 'GOOGLE';

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
    final newBonusLetters = [
      ...state.activatedBonusLetters,
      event.letterIndex,
    ];

    if (newBonusLetters.length == _bonusLettersLength) {
      emit(
        state.copyWith(
          activatedBonusLetters: [],
          bonusHistory: [
            ...state.bonusHistory,
            GameBonus.word,
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(activatedBonusLetters: newBonusLetters),
      );
    }
  }
}
