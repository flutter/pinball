import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'google_word_state.dart';

class GoogleWordCubit extends Cubit<GoogleWordState> {
  GoogleWordCubit() : super(GoogleWordState.initial());

  static const _lettersInGoogle = 6;

  int _lastLitLetter = 0;

  void onRolloverContacted() {
    final spriteStatesMap = {...state.letterSpriteStates};
    if (_lastLitLetter < _lettersInGoogle) {
      spriteStatesMap.update(
        _lastLitLetter,
        (_) => GoogleLetterSpriteState.lit,
      );
      emit(GoogleWordState(letterSpriteStates: spriteStatesMap));
      _lastLitLetter++;
    }
  }

  void onBonusAwarded() {
    emit(GoogleWordState.initial());
    _lastLitLetter = 0;
  }
}
