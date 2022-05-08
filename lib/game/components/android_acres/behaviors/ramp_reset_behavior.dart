import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_reset_behavior}
/// Reset [SpaceshipRamp] state when GameState.rounds changes.
/// /// {@endtemplate}
class RampResetBehavior extends Component with ParentIsA<SpaceshipRamp> {
  /// {@macro ramp_reset_behavior}
  RampResetBehavior() : super();

  /// Creates a [RampResetBehavior].
  ///
  /// This can be used for testing [RampResetBehavior] in isolation.
  @visibleForTesting
  RampResetBehavior.test() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (previousState, newState) =>
            previousState.rounds != newState.rounds,
        onNewState: (state) {
          readBloc<SpaceshipRampCubit, SpaceshipRampState>().onReset();
        },
      ),
    );
  }
}
