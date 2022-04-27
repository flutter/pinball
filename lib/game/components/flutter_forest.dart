// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [DashNestBumper]s.
///
/// When all [DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [DashNestBumper.main] releases a new [Ball].
/// {@endtemplate}
class FlutterForest extends Component
    with Controls<_FlutterForestController>, HasGameRef<PinballGame> {
  /// {@macro flutter_forest}
  FlutterForest()
      : super(
          children: [
            Signpost(
              children: [
                ScoringBehaviour(points: 20),
              ],
            )..initialPosition = Vector2(8.35, -58.3),
            DashNestBumper.main(
              children: [
                ScoringBehaviour(points: 20),
              ],
            )..initialPosition = Vector2(18.55, -59.35),
            DashNestBumper.a(
              children: [
                ScoringBehaviour(points: 20),
              ],
            )..initialPosition = Vector2(8.95, -51.95),
            DashNestBumper.b(
              children: [
                ScoringBehaviour(points: 20),
              ],
            )..initialPosition = Vector2(23.3, -46.75),
            DashAnimatronic()..position = Vector2(20, -66),
          ],
        ) {
    controller = _FlutterForestController(this);
  }
}

class _FlutterForestController extends ComponentController<FlutterForest>
    with HasGameRef<PinballGame> {
  _FlutterForestController(FlutterForest flutterForest) : super(flutterForest);

  final _activatedBumpers = <DashNestBumper>{};

  void activateBumper(DashNestBumper dashNestBumper) {
    if (!_activatedBumpers.add(dashNestBumper)) return;

    dashNestBumper.activate();

    final activatedBonus = _activatedBumpers.length == 3;
    if (activatedBonus) {
      _addBonusBall();

      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.dashNest));
      _activatedBumpers
        ..forEach((bumper) => bumper.deactivate())
        ..clear();

      component.firstChild<DashAnimatronic>()?.playing = true;
    }
  }

  Future<void> _addBonusBall() async {
    await gameRef.add(
      ControlledBall.bonus(characterTheme: gameRef.characterTheme)
        ..initialPosition = Vector2(17.2, -52.7),
    );
  }
}
