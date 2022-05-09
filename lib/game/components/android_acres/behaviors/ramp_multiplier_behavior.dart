import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Increases the multiplier when a [Ball] is shot 5 times into the
/// [SpaceshipRamp].
class RampMultiplierBehavior extends Component
    with FlameBlocListenable<SpaceshipRampCubit, SpaceshipRampState> {
  @override
  bool listenWhen(
    SpaceshipRampState previousState,
    SpaceshipRampState newState,
  ) {
    final hitsIncreased = previousState.hits < newState.hits;
    final achievedFiveShots = newState.hits % 5 == 0;
    final notMaxMultiplier =
        !readBloc<GameBloc, GameState>().state.isMaxMultiplier;
    return hitsIncreased & achievedFiveShots && notMaxMultiplier;
  }

  @override
  void onNewState(SpaceshipRampState state) {
    readBloc<GameBloc, GameState>().add(const MultiplierIncreased());
  }
}
