import 'package:bloc/bloc.dart';

part 'sparky_bumper_state.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class SparkyBumperCubit extends Cubit<SparkyBumperState> {
  // ignore: public_member_api_docs
  SparkyBumperCubit() : super(SparkyBumperState.active);

  /// Event added when a bumper contacts with a ball.
  void onBallContacted() {
    emit(SparkyBumperState.inactive);
  }

  /// Event added when a bumper finishes blinking.
  void onBlinked() {
    emit(SparkyBumperState.active);
  }
}
