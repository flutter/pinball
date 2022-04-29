// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<RoundLost>(_onRoundLost);
    on<Scored>(_onScored);
    on<MultiplierIncreased>(_onIncreasedMultiplier);
    on<BonusActivated>(_onBonusActivated);
    on<SparkyTurboChargeActivated>(_onSparkyTurboChargeActivated);
  }

  void _onRoundLost(RoundLost event, Emitter emit) {
    final score = state.score * state.multiplier;
    final roundsLeft = math.max(state.rounds - 1, 0);

    emit(
      state.copyWith(
        score: score,
        multiplier: 1,
        rounds: roundsLeft,
      ),
    );
  }

  void _onScored(Scored event, Emitter emit) {
    if (!state.isGameOver) {
      emit(
        state.copyWith(score: state.score + event.points),
      );
    }
  }

  void _onIncreasedMultiplier(MultiplierIncreased event, Emitter emit) {
    if (!state.isGameOver) {
      emit(
        state.copyWith(
          multiplier: math.min(state.multiplier + 1, 6),
        ),
      );
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
