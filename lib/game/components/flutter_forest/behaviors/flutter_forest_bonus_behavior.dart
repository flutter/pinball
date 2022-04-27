import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// When all [DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [DashNestBumper.main] releases a new [Ball].
class FlutterForestBonusBehavior extends Component
    with ParentIsA<FlutterForest>, HasGameRef<PinballGame> {
  @override
  void onMount() {
    super.onMount();
    // TODO(alestiago): Refactor subscription management once the following is
    // merged:
    // https://github.com/flame-engine/flame/pull/1538
    parent.bloc.stream.listen(_onNewState);

    final bumpers = parent.children.whereType<DashNestBumper>();
    for (final bumper in bumpers) {
      bumper.bloc.stream.listen((state) {
        if (state == DashNestBumperState.active) {
          parent.bloc.onBumperActivated(bumper);
        }
      });
    }
  }

  void _onNewState(FlutterForestState state) {
    if (state.hasBonus) {
      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.dashNest));

      gameRef.add(
        ControlledBall.bonus(theme: gameRef.theme)
          ..initialPosition = Vector2(17.2, -52.7),
      );
      parent.firstChild<DashAnimatronic>()?.playing = true;
      for (final bumper in state.activatedBumpers) {
        bumper.bloc.onReset();
      }

      parent.bloc.onBonusApplied();
    }
  }
}
