import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Toggle each [Multiplier] when GameState.multiplier changes.
class MultipliersBehavior extends Component
    with HasGameRef<PinballGame>, ParentIsA<Multipliers> {
  @override
  void onMount() {
    super.onMount();

    var previousMultiplier = 1;

    // TODO(ruimiguel): filter only when multiplier has change.
    gameRef.read<GameBloc>().stream.listen((state) {
      if (state.multiplier != previousMultiplier) {
        previousMultiplier = state.multiplier;

        final multipliers = parent.children.whereType<Multiplier>();
        for (final multiplier in multipliers) {
          multiplier.bloc.toggle(state.multiplier);
        }
      }
    });
  }
}
