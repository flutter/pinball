import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Reset [SpaceshipRamp] state when GameState.rounds changes.
class RampResetBehavior extends Component
    with FlameBlocListenable<GameBloc, GameState> {
  @override
  bool listenWhen(GameState previousState, GameState newState) {
    return previousState.rounds != newState.rounds;
  }

  @override
  void onNewState(GameState state) {
    readBloc<SpaceshipRampCubit, SpaceshipRampState>().onReset();
  }
}
