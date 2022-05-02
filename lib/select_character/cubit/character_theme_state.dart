// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

part of 'character_theme_cubit.dart';

class CharacterThemeState extends Equatable {
  const CharacterThemeState(this.characterTheme);

  const CharacterThemeState.initial() : characterTheme = const DashTheme();

  final CharacterTheme characterTheme;

  bool get isSparkySelected => characterTheme == const SparkyTheme();

  bool get isDashSelected => characterTheme == const DashTheme();

  bool get isAndroidSelected => characterTheme == const AndroidTheme();

  bool get isDinoSelected => characterTheme == const DinoTheme();

  @override
  List<Object> get props => [characterTheme];
}
