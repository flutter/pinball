import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// Toggle each [Multiplier] when GameState.multiplier changes.
class MultipliersBehavior extends Component
    with ParentIsA<Multipliers>, FlameBlocListenable<GameBloc, GameState> {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.multiplier != newState.multiplier;
  }

  @override
  void onNewState(GameState state) {
    final multipliers = parent.children.whereType<Multiplier>();
    for (final multiplier in multipliers) {
      multiplier.bloc.next(state.multiplier);
    }
  }
}
