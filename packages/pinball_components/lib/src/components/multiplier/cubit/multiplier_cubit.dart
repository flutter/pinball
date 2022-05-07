import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'multiplier_state.dart';

class MultiplierCubit extends Cubit<MultiplierState> {
  MultiplierCubit(MultiplierValue multiplierValue)
      : super(MultiplierState.initial(multiplierValue));

  /// Event added when the game's current multiplier changes.
  void next(int multiplier) {
    if (state.value.equals(multiplier)) {
      if (state.spriteState == MultiplierSpriteState.dimmed) {
        emit(state.copyWith(spriteState: MultiplierSpriteState.lit));
      }
    } else {
      if (state.spriteState == MultiplierSpriteState.lit) {
        emit(state.copyWith(spriteState: MultiplierSpriteState.dimmed));
      }
    }
  }
}
