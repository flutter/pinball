import 'dart:async';

import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class BonusBehaviour extends Component
    with HasGameRef<PinballGame>, ParentIsA<GoogleWord> {
  BonusBehaviour(
    Iterable<GoogleLetter> googleLetters,
  ) : _googleLetters = googleLetters;

  Iterable<GoogleLetter> _googleLetters;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (final letter in _googleLetters) {
      letter.bloc.stream.listen((_) {
        final achievedBonus = _googleLetters
            .every((letter) => letter.bloc.state == GoogleLetterState.active);

        if (achievedBonus) {
          gameRef.audio.googleBonus();
          gameRef
              .read<GameBloc>()
              .add(const BonusActivated(GameBonus.googleWord));
          for (final letter in _googleLetters) {
            letter.bloc.onReset();
          }
        }
      });
    }
  }
}
