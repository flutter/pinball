import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_progress_behavior}
/// Changes arrow lit when a [Ball] is shot into the [SpaceshipRamp].
/// {@endtemplate}
class RampProgressBehavior extends Component {
  /// {@macro ramp_progress_behavior}
  RampProgressBehavior() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<SpaceshipRampCubit, SpaceshipRampState>(
        listenWhen: (previousState, newState) =>
            previousState.hits != newState.hits && newState.hits != 0,
        onNewState: (state) {
          final gameBloc = readBloc<GameBloc, GameState>();
          final spaceshipCubit =
              readBloc<SpaceshipRampCubit, SpaceshipRampState>();

          final canProgress = !gameBloc.state.isMaxMultiplier ||
              (gameBloc.state.isMaxMultiplier && !state.fullArrowLit);

          if (canProgress) {
            spaceshipCubit.onProgressed();
          }

          if (spaceshipCubit.state.fullArrowLit &&
              !gameBloc.state.isMaxMultiplier) {
            spaceshipCubit.onProgressed();
          }
        },
      ),
    );
  }
}
