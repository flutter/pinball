import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// Toggle each [Multiball] when there is a bonus ball.
class MultiballsBehavior extends Component
    with ParentIsA<Multiballs>, FlameBlocListenable<GameBloc, GameState> {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final hasChanged = previousState?.bonusHistory != newState.bonusHistory;
    final lastBonusIsMultiball = newState.bonusHistory.isNotEmpty &&
        (newState.bonusHistory.last == GameBonus.dashNest ||
            newState.bonusHistory.last == GameBonus.googleWord);

    return hasChanged && lastBonusIsMultiball;
  }

  @override
  void onNewState(GameState state) {
    parent.children.whereType<Multiball>().forEach((multiball) {
      multiball.bloc.onAnimate();
    });
  }
}
