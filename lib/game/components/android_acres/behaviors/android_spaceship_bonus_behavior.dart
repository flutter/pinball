import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.androidSpaceship] when [AndroidSpaceship] is activated.
class AndroidSpaceshipBonusBehavior extends Component
    with HasGameRef<PinballGame>, ParentIsA<AndroidAcres> {
  @override
  void onMount() {
    super.onMount();
    final androidSpaceship = parent.firstChild<AndroidSpaceship>()!;

    // TODO(alestiago): Refactor subscription management once the following is
    // merged:
    // https://github.com/flame-engine/flame/pull/1538
    androidSpaceship.bloc.stream.listen((_) {
      if (androidSpaceship.bloc.state == AndroidSpaceshipState.activated) {
        gameRef
            .read<GameBloc>()
            .add(const BonusActivated(GameBonus.androidSpaceship));
        androidSpaceship.bloc.onBonusAwarded();
      }
    });
  }
}
