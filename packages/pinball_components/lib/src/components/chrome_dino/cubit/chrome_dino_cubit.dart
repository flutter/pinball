// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'chrome_dino_state.dart';

class ChromeDinoCubit extends Cubit<ChromeDinoState> {
  ChromeDinoCubit() : super(const ChromeDinoState.inital());

  void onOpenMouth() {
    emit(state.copyWith(isMouthOpen: true));
  }

  void onCloseMouth() {
    emit(state.copyWith(isMouthOpen: false));
  }

  void onChomp(Ball ball) {
    if (ball != state.ball) {
      emit(state.copyWith(status: ChromeDinoStatus.chomping, ball: ball));
    }
  }

  void onSpit() {
    emit(
      ChromeDinoState(
        status: ChromeDinoStatus.idle,
        isMouthOpen: state.isMouthOpen,
      ),
    );
  }
}
