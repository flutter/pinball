// ignore_for_file: public_member_api_docs
// TODO(allisonryan0002): Document this section when the API is stable.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'select_character_state.dart';

class SelectCharacterCubit extends Cubit<SelectCharacterState> {
  SelectCharacterCubit() : super(const SelectCharacterState.initial());

  void characterSelected(CharacterTheme characterTheme) {
    emit(SelectCharacterState(PinballTheme(characterTheme: characterTheme)));
  }
}
