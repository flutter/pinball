import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alien_bumper_state.dart';

class AlienBumperCubit extends Cubit<AlienBumperState> {
  AlienBumperCubit() : super(AlienBumperState.active);

  void onBallContacted() {
    emit(AlienBumperState.inactive);
    // Future<void>.delayed(const Duration(milliseconds: 500)).whenComplete(
    //   () => emit(AlienBumperState.active),
    // );
  }

  void onAnimated() {
    emit(AlienBumperState.active);
  }
}
