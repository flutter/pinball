// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'google_letter_state.dart';

class GoogleLetterCubit extends Cubit<GoogleLetterState> {
  GoogleLetterCubit() : super(GoogleLetterState.dimmed);

  void onBallContacted() {
    emit(GoogleLetterState.lit);
  }

  void onReset() {
    emit(GoogleLetterState.dimmed);
  }
}
