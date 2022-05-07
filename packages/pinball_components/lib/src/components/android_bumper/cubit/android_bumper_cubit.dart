import 'package:bloc/bloc.dart';

part 'android_bumper_state.dart';

class AndroidBumperCubit extends Cubit<AndroidBumperState> {
  AndroidBumperCubit() : super(AndroidBumperState.lit);

  void onBallContacted() {
    emit(AndroidBumperState.dimmed);
  }

  void onBlinked() {
    emit(AndroidBumperState.lit);
  }
}
