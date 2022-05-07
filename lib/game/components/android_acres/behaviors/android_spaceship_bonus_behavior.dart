import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.androidSpaceship] when [AndroidSpaceship] has a bonus.
class AndroidSpaceshipBonusBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        listenWhen: (_, state) => state == AndroidSpaceshipState.withBonus,
        onNewState: (state) {
          readBloc<GameBloc, GameState>().add(
            const BonusActivated(GameBonus.androidSpaceship),
          );
          readBloc<AndroidSpaceshipCubit, AndroidSpaceshipState>()
              .onBonusAwarded();
        },
      ),
    );
  }
}
