import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Changes arrow lit when a [Ball] is shot into the [SpaceshipRamp].
class RampProgressBehavior extends Component
    with FlameBlocListenable<SpaceshipRampCubit, SpaceshipRampState> {
  @override
  bool listenWhen(
    SpaceshipRampState previousState,
    SpaceshipRampState newState,
  ) {
    return previousState.hits < newState.hits;
  }

  @override
  void onNewState(SpaceshipRampState state) {
    final gameBloc = readBloc<GameBloc, GameState>();
    final spaceshipCubit = readBloc<SpaceshipRampCubit, SpaceshipRampState>();

    final canProgress = !gameBloc.state.isMaxMultiplier ||
        (gameBloc.state.isMaxMultiplier && !state.arrowFullyLit);

    if (canProgress) {
      spaceshipCubit.onProgressed();
    }

    if (spaceshipCubit.state.arrowFullyLit && !gameBloc.state.isMaxMultiplier) {
      spaceshipCubit.onProgressed();
    }
  }
}
