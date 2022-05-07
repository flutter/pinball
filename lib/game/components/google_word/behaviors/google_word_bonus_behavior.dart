import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.googleWord] when all [GoogleLetter]s are activated.
class GoogleWordBonusBehavior extends Component
    with ParentIsA<GoogleWord>, FlameBlocReader<GameBloc, GameState> {
  @override
  void onMount() {
    super.onMount();

    final googleLetters = parent.children.whereType<GoogleLetter>();
    for (final letter in googleLetters) {
      letter.bloc.stream.listen((_) {
        final achievedBonus = googleLetters
            .every((letter) => letter.bloc.state == GoogleLetterState.lit);

        if (achievedBonus) {
          bloc.add(const BonusActivated(GameBonus.googleWord));
          for (final letter in googleLetters) {
            letter.bloc.onReset();
          }
        }
      });
    }
  }
}
