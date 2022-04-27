import 'package:bloc/bloc.dart';

part 'dash_nest_bumper_state.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class DashNestBumperCubit extends Cubit<DashNestBumperState> {
  // ignore: public_member_api_docs
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
