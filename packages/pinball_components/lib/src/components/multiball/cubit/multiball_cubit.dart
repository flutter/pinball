import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'multiball_state.dart';

class MultiballCubit extends Cubit<MultiballState> {
  MultiballCubit() : super(const MultiballState.initial());

  void onAnimate() {
    emit(state.copyWith(isAnimating: true));
  }

  void onStop() {
    emit(state.copyWith(isAnimating: false));
  }

  void onBlinked() {
    switch (state.spriteState) {
      case MultiballSpriteState.lit:
        emit(
          state.copyWith(lightState: MultiballSpriteState.dimmed),
        );
        break;
      case MultiballSpriteState.dimmed:
        emit(
          state.copyWith(lightState: MultiballSpriteState.lit),
        );
        break;
    }
  }
}
