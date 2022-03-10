// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.initial());

  void characterSelected(CharacterTheme characterTheme) {
    emit(ThemeState(PinballTheme(characterTheme: characterTheme)));
  }
}
