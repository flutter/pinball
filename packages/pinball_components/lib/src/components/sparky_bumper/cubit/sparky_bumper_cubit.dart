import 'package:bloc/bloc.dart';

part 'sparky_bumper_state.dart';

class SparkyBumperCubit extends Cubit<SparkyBumperState> {
  SparkyBumperCubit() : super(SparkyBumperState.lit);

  void onBallContacted() {
    emit(SparkyBumperState.dimmed);
  }

  void onBlinked() {
    emit(SparkyBumperState.lit);
  }
}
