import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spaceship_ramp_state.dart';

class SpaceshipRampCubit extends Cubit<SpaceshipRampState> {
  SpaceshipRampCubit() : super(const SpaceshipRampState.initial());

  void onAscendingBallEntered() {
    emit(
      state.copyWith(hits: state.hits + 1),
    );
  }
}
