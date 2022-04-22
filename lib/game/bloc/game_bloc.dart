// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<BallLost>(_onBallLost);
    on<Scored>(_onScored);
    on<MultiplierIncreased>(_onIncreasedMultiplier);
    on<BonusActivated>(_onBonusActivated);
    on<SparkyTurboChargeActivated>(_onSparkyTurboChargeActivated);
  }

  void _onBallLost(BallLost event, Emitter emit) {
    var score = state.score;
    var multiplier = state.multiplier;
    var ballsLeft = event.ballsLeft;
    var roundsLeft = state.rounds;

    if (ballsLeft < 1) {
      score = score * state.multiplier;
      multiplier = 1;
      ballsLeft = 1;
      roundsLeft = state.rounds - 1;
    }

    emit(
      state.copyWith(
        score: score,
        multiplier: multiplier,
        balls: ballsLeft,
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
