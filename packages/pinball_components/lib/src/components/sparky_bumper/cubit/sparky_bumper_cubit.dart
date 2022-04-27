// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'sparky_bumper_state.dart';

class SparkyBumperCubit extends Cubit<SparkyBumperState> {
  SparkyBumperCubit() : super(SparkyBumperState.active);

  void onBallContacted() {
    emit(SparkyBumperState.inactive);
  }

  void onBlinked() {
    emit(SparkyBumperState.active);
  }
}
