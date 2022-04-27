import 'package:bloc/bloc.dart';

part 'alien_bumper_state.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class AlienBumperCubit extends Cubit<AlienBumperState> {
  // ignore: public_member_api_docs
  AlienBumperCubit() : super(AlienBumperState.active);

  /// Event added when the bumper contacts with a ball.
  void onBallContacted() {
    emit(AlienBumperState.inactive);
  }

  /// Event added when the bumper finishes blinking.
  void onBlinked() {
    emit(AlienBumperState.active);
  }
}
