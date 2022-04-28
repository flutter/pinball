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

    gameRef.read<GameBloc>().stream.listen((state) {
      final hasMultiball = state.bonusHistory.contains(GameBonus.dashNest);

      if (hasMultiball) {
        final multiballs = parent.children.whereType<Multiball>();
        for (final multiball in multiballs) {
          multiball.bloc.animate();
        }
      }
    });
  }
}
