// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

part of 'character_theme_cubit.dart';

class CharacterThemeState extends Equatable {
  const CharacterThemeState(this.selectedCharacter);

  const CharacterThemeState.initial() : selectedCharacter = const DashTheme();

  final CharacterTheme selectedCharacter;

  @override
  List<Object> get props => [selectedCharacter];
}
