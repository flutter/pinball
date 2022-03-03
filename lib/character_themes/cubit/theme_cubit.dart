import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball/character_themes/character_themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(DashTheme()));

  void themeSelected(CharacterTheme theme) {
    emit(ThemeState(theme));
  }
}
