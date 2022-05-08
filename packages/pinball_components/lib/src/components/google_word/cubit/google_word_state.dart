part of 'google_word_cubit.dart';

class GoogleWordState extends Equatable {
  const GoogleWordState({required this.letterSpriteStates});

  GoogleWordState.initial()
      : this(
          letterSpriteStates: <int, GoogleLetterSpriteState>{
            0: GoogleLetterSpriteState.dimmed,
            1: GoogleLetterSpriteState.dimmed,
            2: GoogleLetterSpriteState.dimmed,
            3: GoogleLetterSpriteState.dimmed,
            4: GoogleLetterSpriteState.dimmed,
            5: GoogleLetterSpriteState.dimmed,
          },
        );

  final Map<int, GoogleLetterSpriteState> letterSpriteStates;

  @override
  List<Object> get props => [...letterSpriteStates.values];
}
