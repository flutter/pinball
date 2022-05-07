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

  void onProgressed() {
    final index = ArrowLightState.values.indexOf(state.lightState);

    emit(
      state.copyWith(
        lightState:
            ArrowLightState.values[(index + 1) % ArrowLightState.values.length],
        animationState: ArrowAnimationState.idle,
      ),
    );
  }

  bool isFullyProgressed() =>
      state.lightState == ArrowLightState.active5 &&
      state.animationState == ArrowAnimationState.idle;

  void onReset() {
    emit(
      state.copyWith(
        lightState: ArrowLightState.inactive,
        animationState: ArrowAnimationState.idle,
      ),
    );
  }

  void onAnimate() {
    emit(
      state.copyWith(animationState: ArrowAnimationState.blinking),
    );
  }

  void onStop() {
    emit(
      state.copyWith(
        lightState: ArrowLightState.inactive,
        animationState: ArrowAnimationState.idle,
      ),
    );
  }

  void onBlink() {
    switch (state.lightState) {
      case ArrowLightState.inactive:
        emit(
          state.copyWith(lightState: ArrowLightState.active1),
        );
        break;
      case ArrowLightState.active1:
        emit(
          state.copyWith(lightState: ArrowLightState.active2),
        );
        break;
      case ArrowLightState.active2:
        emit(
          state.copyWith(lightState: ArrowLightState.active3),
        );
        break;
      case ArrowLightState.active3:
        emit(
          state.copyWith(lightState: ArrowLightState.active4),
        );
        break;
      case ArrowLightState.active4:
        emit(
          state.copyWith(lightState: ArrowLightState.active5),
        );
        break;
      case ArrowLightState.active5:
        emit(
          state.copyWith(lightState: ArrowLightState.inactive),
        );
        break;
    }
  }
}
