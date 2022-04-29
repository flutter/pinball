import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Toggle each [Multiball] when there is a bonus ball.
class MultiballsBehavior extends Component
    with HasGameRef<PinballGame>, ParentIsA<Multiballs> {
  @override
  void onMount() {
    super.onMount();

    var _previousMultiballBonus = 0;

    gameRef.read<GameBloc>().stream.listen((state) {
      // TODO(ruimiguel): only when state.bonusHistory dashNest has changed
      final multiballBonus = state.bonusHistory.fold<int>(
        0,
        (previousValue, bonus) {
          if (bonus == GameBonus.dashNest) {
            previousValue++;
          }
          return previousValue;
        },
      );

      if (_previousMultiballBonus != multiballBonus) {
        _previousMultiballBonus = multiballBonus;

        final hasMultiball = state.bonusHistory.contains(GameBonus.dashNest);

        if (hasMultiball) {
          parent.children.whereType<Multiball>().forEach((multiball) {
            multiball.bloc.onAnimate();
          });
        }
      }
    });
  }
}
