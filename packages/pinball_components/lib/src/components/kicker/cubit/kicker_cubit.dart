// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'kicker_state.dart';

class KickerCubit extends Cubit<KickerState> {
  KickerCubit() : super(KickerState.lit);

  void onBallContacted() {
    emit(KickerState.dimmed);
  }

  void onBlinked() {
    emit(KickerState.lit);
  }
}
