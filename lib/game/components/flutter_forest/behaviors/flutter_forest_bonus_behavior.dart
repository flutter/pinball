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

    final bumpers = parent.children.whereType<DashNestBumper>();
    for (final bumper in bumpers) {
      // TODO(alestiago): Refactor subscription management once the following is
      // merged:
      // https://github.com/flame-engine/flame/pull/1538
      bumper.bloc.stream.listen((state) {
        final achievedBonus = bumpers.every(
          (bumper) => bumper.bloc.state == DashNestBumperState.active,
        );

        if (achievedBonus) {
          gameRef
              .read<GameBloc>()
              .add(const BonusActivated(GameBonus.dashNest));
          gameRef.add(
            ControlledBall.bonus(characterTheme: gameRef.characterTheme)
              ..initialPosition = Vector2(17.2, -52.7),
          );
          parent.firstChild<DashAnimatronic>()?.playing = true;

          for (final bumper in bumpers) {
            bumper.bloc.onReset();
          }
        }
      });
    }
  }
}
