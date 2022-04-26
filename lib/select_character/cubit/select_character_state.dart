// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

part of 'select_character_cubit.dart';

class SelectCharacterState extends Equatable {
  const SelectCharacterState(this.selectedCharacter);

  const SelectCharacterState.initial()
      : selectedCharacter = const PinballTheme(characterTheme: DashTheme());

  final PinballTheme selectedCharacter;

  @override
  List<Object> get props => [selectedCharacter];
}
