part of 'google_word_cubit.dart';

class GoogleWordState extends Equatable {
  const GoogleWordState({required this.letterSpriteStates});

  GoogleWordState.initial()
      : this(
          letterSpriteStates: {
            for (var i = 0; i <= 5; i++) i: GoogleLetterSpriteState.dimmed
          },
        );

  final Map<int, GoogleLetterSpriteState> letterSpriteStates;

  @override
  List<Object> get props => [...letterSpriteStates.values];
}
