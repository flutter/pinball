import 'package:bloc/bloc.dart';

part 'dash_bumper_state.dart';

class DashBumperCubit extends Cubit<DashBumperState> {
  DashBumperCubit() : super(DashBumperState.inactive);

  /// Event added when the bumper contacts with a ball.
  void onBallContacted() {
    emit(DashBumperState.active);
  }

  /// Event added when the bumper should return to its initial configuration.
  void onReset() {
    emit(DashBumperState.inactive);
  }
}
