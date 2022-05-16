import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'dash_bumpers_state.dart';

class DashBumpersCubit extends Cubit<DashBumpersState> {
  DashBumpersCubit() : super(DashBumpersState.initial());

  /// Event added when a ball contacts with a bumper.
  void onBallContacted(DashBumperId id) {
    final spriteStatesMap = {...state.bumperSpriteStates};
    emit(
      DashBumpersState(
        bumperSpriteStates: spriteStatesMap
          ..update(id, (_) => DashBumperSpriteState.active),
      ),
    );
  }

  /// Event added when the bumpers should return to their initial
  /// configurations.
  void onReset() {
    emit(DashBumpersState.initial());
  }
}
