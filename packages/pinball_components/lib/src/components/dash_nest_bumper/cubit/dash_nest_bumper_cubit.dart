import 'package:bloc/bloc.dart';

part 'dash_nest_bumper_state.dart';

class DashNestBumperCubit extends Cubit<DashNestBumperState> {
  DashNestBumperCubit() : super(DashNestBumperState.inactive);

  /// Event added when the bumper contacts with a ball.
  void onBallContacted() {
    emit(DashNestBumperState.active);
  }

  /// Event added when the bumper should return to its initial configuration.
  void onReset() {
    emit(DashNestBumperState.inactive);
  }
}
