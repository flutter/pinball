import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spaceship_ramp_state.dart';

class SpaceshipRampCubit extends Cubit<SpaceshipRampState> {
  SpaceshipRampCubit() : super(const SpaceshipRampState.initial());

  void onAscendingBallEntered() => emit(state.copyWith(hits: state.hits + 1));

  void onProgressed() {
    final index = ArrowLightState.values.indexOf(state.lightState);
    emit(
      state.copyWith(
        lightState:
            ArrowLightState.values[(index + 1) % ArrowLightState.values.length],
      ),
    );
  }

  void onReset() => emit(const SpaceshipRampState.initial());
}
