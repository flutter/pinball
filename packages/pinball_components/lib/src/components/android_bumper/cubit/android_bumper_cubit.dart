// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'android_bumper_state.dart';

class AndroidBumperCubit extends Cubit<AndroidBumperState> {
  AndroidBumperCubit() : super(AndroidBumperState.dimmed);

  void onBallContacted() {
    emit(AndroidBumperState.dimmed);
  }

  void onBlinked() {
    emit(AndroidBumperState.lit);
  }
}
