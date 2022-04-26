// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'character_theme_state.dart';

class CharacterThemeCubit extends Cubit<CharacterThemeState> {
  CharacterThemeCubit() : super(const CharacterThemeState.initial());

  void characterSelected(CharacterTheme characterTheme) {
    emit(CharacterThemeState(characterTheme));
  }
}
