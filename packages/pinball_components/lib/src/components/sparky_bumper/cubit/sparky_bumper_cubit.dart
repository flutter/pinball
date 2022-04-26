import 'package:bloc/bloc.dart';

part 'sparky_bumper_state.dart';

class SparkyBumperCubit extends Cubit<SparkyBumperState> {
  SparkyBumperCubit() : super(SparkyBumperState.active);

  void onBallContacted() {
    emit(SparkyBumperState.inactive);
    // Future<void>.delayed(const Duration(milliseconds: 500)).whenComplete(
    //   () => emit(AlienBumperState.active),
    // );
  }

  void onAnimated() {
    emit(SparkyBumperState.active);
  }
}