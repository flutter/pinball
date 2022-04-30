// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'kicker_state.dart';

class KickerCubit extends Cubit<KickerState> {
  KickerCubit() : super(KickerState.dimmed);

  void onBallContacted() {
    emit(KickerState.lit);
  }

  void onBlinked() {
    emit(KickerState.dimmed);
  }
}
