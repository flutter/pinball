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
    on<BonusActivated>(_onBonusActivated);
    on<DashNestActivated>(_onDashNestActivated);
    on<SparkyTurboChargeActivated>(_onSparkyTurboChargeActivated);
  }

  void _onBallLost(BallLost event, Emitter emit) {
    emit(state.copyWith(balls: state.balls - 1));
  }

  void _onScored(Scored event, Emitter emit) {
    if (!state.isGameOver) {
      emit(state.copyWith(score: state.score + event.points));
    }
  }

  void _onBonusActivated(BonusActivated event, Emitter emit) {
    emit(
      state.copyWith(
        bonusHistory: [...state.bonusHistory, event.bonus],
      ),
    );
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
