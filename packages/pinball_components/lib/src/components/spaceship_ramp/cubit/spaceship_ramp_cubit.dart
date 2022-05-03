// ignore_for_file: public_member_api_docs

import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'spaceship_ramp_state.dart';

class SpaceshipRampCubit extends Cubit<SpaceshipRampState> {
  SpaceshipRampCubit() : super(SpaceshipRampState.initial());

  void onDoor(Ball ball) {
    if (!state.balls.contains(ball)) {
      emit(
        state.copyWith(
          balls: state.balls..add(ball),
          status: SpaceshipRampStatus.withoutBonus,
        ),
      );
    }
  }

  void onInside(Ball ball) {
    if (state.balls.contains(ball)) {
      final hits = state.hits + 1;
      final bonus = (hits % 10 == 0)
          ? SpaceshipRampStatus.withBonus
          : SpaceshipRampStatus.withoutBonus;
      final shot = hits % 10 != 0;

      emit(
        state.copyWith(
          hits: hits,
          balls: state.balls..remove(ball),
          shot: shot,
          status: bonus,
        ),
      );
    }
  }
}
