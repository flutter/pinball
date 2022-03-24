// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [_DashNestBumper]s.
///
/// When all [_DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [_BigDashNestBumper] releases a new [Ball].
/// {@endtemplate}
// TODO(alestiago): Make a [Blueprint] once nesting [Blueprint] is implemented.
class FlutterForest extends Component
    with HasGameRef<PinballGame>, BlocComponent<GameBloc, GameState> {
  /// {@macro flutter_forest}
  FlutterForest({
    required this.position,
  });

  /// The position of the [FlutterForest] on the [Board].
  final Vector2 position;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.bonusHistory.length ?? 0) <
            newState.bonusHistory.length &&
        newState.bonusHistory.last == GameBonus.dashNest;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    gameRef.add(Ball()..initialPosition = position);
  }

  @override
  Future<void> onLoad() async {
    gameRef.addContactCallback(_DashNestBumperBallContactCallback());

    // TODO(alestiago): adjust positioning once sprites are added.
    final smallLeftNest = _SmallDashNestBumper(id: 'small_left_nest')
      ..initialPosition = position + Vector2(-4.8, 2.8);
    final smallRightNest = _SmallDashNestBumper(id: 'small_right_nest')
      ..initialPosition = position + Vector2(0.5, -5.5);
    final bigNest = _BigDashNestBumper(id: 'big_nest')
      ..initialPosition = position;

    await addAll([
      smallLeftNest,
      smallRightNest,
      bigNest,
    ]);
  }
}

/// {@template dash_nest_bumper}
/// Body that repels a [Ball] on contact.
///
/// When hit, the [GameState.score] is increased.
/// {@endtemplate}
abstract class _DashNestBumper extends BodyComponent<PinballGame>
    with ScorePoints, InitialPosition {
  /// {@template dash_nest_bumper}
  _DashNestBumper({required this.id});

  final String id;
}

class _DashNestBumperBallContactCallback
    extends ContactCallback<_DashNestBumper, Ball> {
  @override
  void begin(_DashNestBumper dashNestBumper, Ball ball, Contact _) {
    dashNestBumper.gameRef.read<GameBloc>().add(
          DashNestActivated(dashNestBumper.id),
        );
  }
}

class _BigDashNestBumper extends _DashNestBumper {
  _BigDashNestBumper({required String id}) : super(id: id);

  @override
  int get points => 20;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2.5;
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _SmallDashNestBumper extends _DashNestBumper {
  _SmallDashNestBumper({required String id}) : super(id: id);

  @override
  int get points => 10;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1;
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
