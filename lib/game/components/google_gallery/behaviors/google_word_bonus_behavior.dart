import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.googleWord] when all [GoogleLetter]s are activated.
class GoogleWordBonusBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<GoogleWordCubit, GoogleWordState>(
        listenWhen: (_, state) => state.letterSpriteStates.values
            .every((element) => element == GoogleLetterSpriteState.lit),
        onNewState: (state) {
          readBloc<GameBloc, GameState>()
              .add(const BonusActivated(GameBonus.googleWord));
          readBloc<GoogleWordCubit, GoogleWordState>().onBonusAwarded();
          add(BonusBallSpawningBehavior());
          add(GoogleWordAnimatingBehavior());
        },
      ),
    );
  }
}
