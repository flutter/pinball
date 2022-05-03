import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.googleWord] when all [GoogleLetter]s are activated.
class GoogleWordBonusBehavior extends Component
    with HasGameRef<PinballGame>, ParentIsA<GoogleWord> {
  @override
  void onMount() {
    super.onMount();

    final googleLetters = parent.children.whereType<GoogleLetter>();
    for (final letter in googleLetters) {
      // TODO(alestiago): Refactor subscription management once the following is
      // merged:
      // https://github.com/flame-engine/flame/pull/1538
      letter.bloc.stream.listen((_) {
        final achievedBonus = googleLetters
            .every((letter) => letter.bloc.state == GoogleLetterState.lit);

        if (achievedBonus) {
          gameRef.audio.googleBonus();
          gameRef
              .read<GameBloc>()
              .add(const BonusActivated(GameBonus.googleWord));
          for (final letter in googleLetters) {
            letter.bloc.onReset();
          }
        }
      });
    }
  }
}
