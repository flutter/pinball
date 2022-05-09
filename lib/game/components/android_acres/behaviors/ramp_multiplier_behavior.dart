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
    final hasChanged =
        previousState.hits != newState.hits && newState.hits != 0;
    final achievedFiveShots = newState.hits % 5 == 0;
    final canIncrease = readBloc<GameBloc, GameState>().state.multiplier != 6;
    return hasChanged && achievedFiveShots && canIncrease;
  }

  @override
  void onNewState(SpaceshipRampState state) {
    readBloc<GameBloc, GameState>().add(const MultiplierIncreased());
  }
}
