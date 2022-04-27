import 'package:bloc/bloc.dart';

part 'google_letter_state.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class GoogleLetterCubit extends Cubit<GoogleLetterState> {
  // ignore: public_member_api_docs
  GoogleLetterCubit() : super(GoogleLetterState.inactive);

  /// Event added when the letter contacts with a ball.
  void onBallContacted() {
    emit(GoogleLetterState.active);
  }

  /// Event added when the letter should return to its initial configuration.
  void onReset() {
    emit(GoogleLetterState.inactive);
  }
}
