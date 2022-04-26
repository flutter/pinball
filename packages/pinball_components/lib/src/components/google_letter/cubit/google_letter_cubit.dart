import 'package:bloc/bloc.dart';

part 'google_letter_state.dart';

class GoogleLetterCubit extends Cubit<GoogleLetterState> {
  GoogleLetterCubit() : super(GoogleLetterState.inactive);

  void onBallContacted() {
    emit(GoogleLetterState.active);
  }

  void onReset() {
    emit(GoogleLetterState.inactive);
  }
}
