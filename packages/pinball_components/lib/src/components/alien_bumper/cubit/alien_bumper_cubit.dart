// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'alien_bumper_state.dart';

class AlienBumperCubit extends Cubit<AlienBumperState> {
  AlienBumperCubit() : super(AlienBumperState.active);

  void onBallContacted() {
    emit(AlienBumperState.inactive);
  }

  void onBlinked() {
    emit(AlienBumperState.active);
  }
}
