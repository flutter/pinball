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
    on<IncreasedMultiplier>(_onIncreasedMultiplier);
    on<AppliedMultiplier>(_onAppliedMultiplier);
    on<ResetMultiplier>(_onResetMultiplier);
    on<BonusActivated>(_onBonusActivated);
    on<SparkyTurboChargeActivated>(_onSparkyTurboChargeActivated);
  }

  void _onBallLost(BallLost event, Emitter emit) {
    emit(state.copyWith(balls: state.balls - 1));
  }

  void _onScored(Scored event, Emitter emit) {
    if (!state.isGameOver) {
      emit(
        state.copyWith(score: state.score + event.points),
      );
    }
  }

  void _onIncreasedMultiplier(IncreasedMultiplier event, Emitter emit) {
    if (!state.isGameOver) {
      emit(state.copyWith(multiplier: state.multiplier + event.increase));
    }
  }

  void _onAppliedMultiplier(AppliedMultiplier event, Emitter emit) {
    if (!state.isGameOver) {
      emit(state.copyWith(score: state.score * state.multiplier));
    }
  }

  void _onResetMultiplier(ResetMultiplier event, Emitter emit) {
    if (!state.isGameOver) {
      emit(state.copyWith(multiplier: 1));
    }
  }

  void _onBonusActivated(BonusActivated event, Emitter emit) {
    emit(
      state.copyWith(
        bonusHistory: [...state.bonusHistory, event.bonus],
      ),
    );
  }

  Future<void> _onSparkyTurboChargeActivated(
    SparkyTurboChargeActivated event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        bonusHistory: [
          ...state.bonusHistory,
          GameBonus.sparkyTurboCharge,
        ],
      ),
    );
  }
}
