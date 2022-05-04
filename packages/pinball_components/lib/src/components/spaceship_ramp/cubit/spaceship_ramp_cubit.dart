// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spaceship_ramp_state.dart';

class SpaceshipRampCubit extends Cubit<SpaceshipRampState> {
  SpaceshipRampCubit() : super(const SpaceshipRampState.initial());

  void onBallInside() {
    final index =
        SpaceshipRampArrowSpriteState.values.indexOf(state.arrowState);

    emit(
      state.copyWith(
        hits: state.hits + 1,
        arrowState: SpaceshipRampArrowSpriteState
            .values[(index + 1) % SpaceshipRampArrowSpriteState.values.length],
      ),
    );
  }
}
