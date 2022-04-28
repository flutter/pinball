// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'multiplier_state.dart';

class MultiplierCubit extends Cubit<MultiplierState> {
  MultiplierCubit(MultiplierValue multiplierValue)
      : super(
          MultiplierState(
            value: multiplierValue,
            spriteState: MultiplierSpriteState.dimmed,
          ),
        );

  /// Event added when the game current multiplier changes.
  void toggle(int multiplier) {
    if (state.equalsTo(multiplier)) {
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

extension on MultiplierState {
  bool equalsTo(int value) {
    switch (this.value) {
      case MultiplierValue.x2:
        return value == 2;
      case MultiplierValue.x3:
        return value == 3;
      case MultiplierValue.x4:
        return value == 4;
      case MultiplierValue.x5:
        return value == 5;
      case MultiplierValue.x6:
        return value == 6;
    }
  }
}
