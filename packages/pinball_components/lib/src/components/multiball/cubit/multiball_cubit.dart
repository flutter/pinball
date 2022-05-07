import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'multiball_state.dart';

class MultiballCubit extends Cubit<MultiballState> {
  MultiballCubit() : super(const MultiballState.initial());

  void onAnimate() {
    emit(
      state.copyWith(animationState: MultiballAnimationState.blinking),
    );
  }

  void onStop() {
    emit(
      state.copyWith(animationState: MultiballAnimationState.idle),
    );
  }

  void onBlink() {
    switch (state.lightState) {
      case MultiballLightState.lit:
        emit(
          state.copyWith(lightState: MultiballLightState.dimmed),
        );
        break;
      case MultiballLightState.dimmed:
        emit(
          state.copyWith(lightState: MultiballLightState.lit),
        );
        break;
    }
  }
}
