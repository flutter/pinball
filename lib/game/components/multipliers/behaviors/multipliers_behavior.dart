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

    // TODO(ruimiguel): filter only when multiplier has change, not every other
    // state.
    gameRef.read<GameBloc>().stream.listen((state) {
      final multipliers = parent.children.whereType<Multiplier>();
      for (final multiplier in multipliers) {
        // TODO(ruimiguel): use here GameState.multiplier when merged
        // https://github.com/VGVentures/pinball/pull/213.
        final currentMultiplier = state.score.bitLength % 6 + 1;

        multiplier.bloc.toggle(currentMultiplier);
      }
    });
  }
}
