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
/// is awarded, and the [BigDashNestBumper] releases a new [Ball].
/// {@endtemplate}
// TODO(alestiago): Make a [Blueprint] once [Blueprint] inherits from
// [Component].
class FlutterForest extends Component
    with Controls<_FlutterForestController>, HasGameRef<PinballGame> {
  /// {@macro flutter_forest}
  FlutterForest() {
    controller = _FlutterForestController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final signPost = FlutterSignPost()..initialPosition = Vector2(8.35, 58.3);

    final bigNest = _ControlledBigDashNestBumper(
      id: 'big_nest_bumper',
    )..initialPosition = Vector2(18.55, -59.35);
    final smallLeftNest = _ControlledSmallDashNestBumper.a(
      id: 'small_nest_bumper_a',
    )..initialPosition = Vector2(8.95, -51.95);
    final smallRightNest = _ControlledSmallDashNestBumper.b(
      id: 'small_nest_bumper_b',
    )..initialPosition = Vector2(23.3, -46.75);
    final dashAnimatronic = DashAnimatronic()..position = Vector2(20, -66);

    await addAll([
      signPost,
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

  final _activatedBumpers = <String>{};

  void activateBumper(String id) {
    if (!_activatedBumpers.add(id)) return;

    final activatedBonus = _activatedBumpers.length == 3;
    if (activatedBonus) {
      // gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.dashNest));
      _addBonusBall();
      _activatedBumpers.clear();
    }
  }

  Future<void> _addBonusBall() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await gameRef.add(
      ControlledBall.bonus(theme: gameRef.theme)
        ..initialPosition = Vector2(17.2, -52.7),
    );
  }
}

class _ControlledBigDashNestBumper extends BigDashNestBumper with ScorePoints {
  _ControlledBigDashNestBumper({
    required this.id,
  });

  final String id;

  @override
  int get points => 20;
}

class _ControlledBigDashNestBumperBallContactCallback
    extends ContactCallback<_ControlledBigDashNestBumper, Ball> {
  @override
  void begin(_ControlledBigDashNestBumper controlledBigDashNestBumper, _, __) {
    (controlledBigDashNestBumper.parent! as FlutterForest)
        .controller
        .activateBumper(controlledBigDashNestBumper.id);
  }
}

class _ControlledSmallDashNestBumper extends SmallDashNestBumper
    with ScorePoints {
  _ControlledSmallDashNestBumper.a({
    required this.id,
  }) : super.a();

  _ControlledSmallDashNestBumper.b({
    required this.id,
  }) : super.b();

  final String id;

  @override
  int get points => 20;
}

class _ControlledSmallDashNestBumperBallContactCallback
    extends ContactCallback<_ControlledSmallDashNestBumper, Ball> {
  @override
  void begin(
    _ControlledSmallDashNestBumper controlledSmallDashNestBumper,
    _,
    __,
  ) {
    (controlledSmallDashNestBumper.parent! as FlutterForest)
        .controller
        .activateBumper(controlledSmallDashNestBumper.id);
  }
}
