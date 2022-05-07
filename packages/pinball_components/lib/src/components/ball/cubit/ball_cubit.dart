import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'ball_state.dart';

class BallCubit extends Cubit<BallState> {
  BallCubit() : super(const BallState.initial());

  void onThemeChanged(CharacterTheme characterTheme) {
    emit(BallState(characterTheme: characterTheme));
  }
}
