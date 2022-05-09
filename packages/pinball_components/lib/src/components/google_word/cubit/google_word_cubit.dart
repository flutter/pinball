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

  void switched() {
    switch (state.letterSpriteStates[0]!) {
      case GoogleLetterSpriteState.lit:
        emit(
          GoogleWordState(
            letterSpriteStates: {
              for (int i = 0; i < _lettersInGoogle; i++)
                if (i.isEven)
                  i: GoogleLetterSpriteState.dimmed
                else
                  i: GoogleLetterSpriteState.lit
            },
          ),
        );
        break;
      case GoogleLetterSpriteState.dimmed:
        emit(
          GoogleWordState(
            letterSpriteStates: {
              for (int i = 0; i < _lettersInGoogle; i++)
                if (i.isEven)
                  i: GoogleLetterSpriteState.lit
                else
                  i: GoogleLetterSpriteState.dimmed
            },
          ),
        );
        break;
    }
  }

  void onBonusAwarded() {
    emit(
      GoogleWordState(
        letterSpriteStates: {
          for (int i = 0; i < _lettersInGoogle; i++)
            if (i.isEven)
              i: GoogleLetterSpriteState.lit
            else
              i: GoogleLetterSpriteState.dimmed
        },
      ),
    );
  }

  void onReset() {
    emit(GoogleWordState.initial());
    _lastLitLetter = 0;
  }
}
