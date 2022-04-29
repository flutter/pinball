import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Toggle each [Multiball] when there is a bonus ball.
class MultiballsBehavior extends Component
    with
        HasGameRef<PinballGame>,
        ParentIsA<Multiballs>,
        BlocComponent<GameBloc, GameState> {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final hasMultiball = newState.bonusHistory.contains(GameBonus.dashNest);
    final hasChanged = previousState?.bonusHistory != newState.bonusHistory;
    return hasChanged && hasMultiball;
  }

  @override
  void onNewState(GameState state) {
    parent.children.whereType<Multiball>().forEach((multiball) {
      multiball.bloc.onAnimate();
    });
  }
}
