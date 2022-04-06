// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<BallLost>(_onBallLost);
    on<Scored>(_onScored);
    on<BonusLetterActivated>(_onBonusLetterActivated);
    on<DashNestActivated>(_onDashNestActivated);
  }

  static const bonusWord = 'GOOGLE';
  static const bonusWordScore = 10000;

  void _onBallLost(BallLost event, Emitter emit) {
    emit(state.copyWith(balls: state.balls - 1));
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

    final achievedBonus = newBonusLetters.length == bonusWord.length;
    if (achievedBonus) {
      emit(
        state.copyWith(
          activatedBonusLetters: [],
          bonusHistory: [
            ...state.bonusHistory,
            GameBonus.word,
          ],
        ),
      );
      add(const Scored(points: bonusWordScore));
    } else {
      emit(
        state.copyWith(activatedBonusLetters: newBonusLetters),
      );
    }
  }

  void _onDashNestActivated(DashNestActivated event, Emitter emit) {
    final newNests = {
      ...state.activatedDashNests,
      event.nestId,
    };

    final achievedBonus = newNests.length == 3;
    if (achievedBonus) {
      emit(
        state.copyWith(
          balls: state.balls + 1,
          activatedDashNests: {},
          bonusHistory: [
            ...state.bonusHistory,
            GameBonus.dashNest,
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(activatedDashNests: newNests),
      );
    }
  }
}
