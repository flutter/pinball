// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
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
  FlutterForest() {
    controller = _FlutterForestController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(_DashNestBumperBallContactCallback());

    final signpost = Signpost()..initialPosition = Vector2(8.35, -58.3);

    final bigNest = _DashNestBumper.main()
      ..initialPosition = Vector2(18.55, -59.35);
    final smallLeftNest = _DashNestBumper.a()
      ..initialPosition = Vector2(8.95, -51.95);
    final smallRightNest = _DashNestBumper.b()
      ..initialPosition = Vector2(23.3, -46.75);
    final dashAnimatronic = DashAnimatronic()..position = Vector2(20, -66);

    await addAll([
      signpost,
      smallLeftNest,
      smallRightNest,
      bigNest,
      dashAnimatronic,
    ]);
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
      ControlledBall.bonus(theme: gameRef.theme)
        ..initialPosition = Vector2(17.2, -52.7),
    );
  }
}

// TODO(alestiago): Revisit ScorePoints logic once the FlameForge2D
// ContactCallback process is enhanced.
class _DashNestBumper extends DashNestBumper with ScorePoints {
  _DashNestBumper.main() : super.main();

  _DashNestBumper.a() : super.a();

  _DashNestBumper.b() : super.b();

  @override
  int get points => 20;
}

class _DashNestBumperBallContactCallback
    extends ContactCallback<DashNestBumper, Ball> {
  @override
  void begin(DashNestBumper dashNestBumper, _, __) {
    final parent = dashNestBumper.parent;
    if (parent is FlutterForest) {
      parent.controller.activateBumper(dashNestBumper);
    }
  }
}
