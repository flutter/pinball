// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'arcade_background_state.dart';

class ArcadeBackgroundCubit extends Cubit<ArcadeBackgroundState> {
  ArcadeBackgroundCubit() : super(const ArcadeBackgroundState.initial());

  void onCharacterSelected(CharacterTheme characterTheme) {
    emit(ArcadeBackgroundState(characterTheme: characterTheme));
  }
}
