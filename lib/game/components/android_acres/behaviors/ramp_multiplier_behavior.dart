import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_multiplier_behavior}
/// Increases the multiplier when a [Ball] is shot 5 times into the
/// [SpaceshipRamp].
/// {@endtemplate}
class RampMultiplierBehavior extends Component {
  /// {@macro ramp_multiplier_behavior}
  RampMultiplierBehavior() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<SpaceshipRampCubit, SpaceshipRampState>(
        listenWhen: (previousState, newState) {
          final hasChanged =
              previousState.hits != newState.hits && newState.hits != 0;
          final achievedFiveShots = newState.hits % 5 == 0;
          final canIncrease =
              readBloc<GameBloc, GameState>().state.multiplier != 6;
          return hasChanged && achievedFiveShots && canIncrease;
        },
        onNewState: (state) {
          readBloc<GameBloc, GameState>().add(const MultiplierIncreased());
        },
      ),
    );
  }
}
