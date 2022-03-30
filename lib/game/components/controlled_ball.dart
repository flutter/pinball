import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template controlled_ball}
/// A [Ball] with a [BallController] attached.
/// {@endtemplate}
abstract class _ControlledBall<T extends BallController> extends Ball
    with Controls<T> {
  _ControlledBall({required Color baseColor}) : super(baseColor: baseColor);
}

/// {@template plunger_ball}
/// A [Ball] that starts at the [Plunger].
///
/// When a [PlungerBall] is lost, it will decrease the [GameState.balls] count,
/// and a new [PlungerBall] is spawned if it's possible.
/// {@endtemplate}
class PlungerBall extends _ControlledBall<PlungerBallController> {
  // TODO(alestiago): Work on a better solution than passing the game.
  /// {@macro plunger_ball}
  PlungerBall(
    PinballGame game, {
    required Plunger plunger,
  }) : super(baseColor: game.theme.characterTheme.ballColor) {
    // TODO(alestiago): Dicuss if this is a good idea.
    initialPosition = Vector2(
      plunger.body.position.x,
      plunger.body.position.y + Ball.size.y,
    );
  }

  @override
  PlungerBallController controllerBuilder() => PlungerBallController(this);
}

/// {@template bonus_ball}
/// {@macro controlled_ball}
///
/// When a [BonusBall] is lost, the [GameState.balls] doesn't change.
/// {@endtemplate}
class BonusBall extends _ControlledBall<BallController> {
  /// {@macro bonus_ball}
  BonusBall(PinballGame game)
      : super(baseColor: game.theme.characterTheme.ballColor);

  @override
  BallController controllerBuilder() => BallController(this);
}

/// {@template debug_ball}
/// [Ball] used in [DebugPinballGame].
/// {@endtemplate}
class DebugBall extends _ControlledBall<BallController> {
  /// {@macro debug_ball}
  DebugBall() : super(baseColor: const Color(0xFFFF0000));

  @override
  BallController controllerBuilder() => BallController(this);
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends ComponentController<Ball> {
  /// {@macro ball_controller}
  BallController(Ball ball) : super(ball);

  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  void lost() {
    component.shouldRemove = true;
  }
}

/// {@macro ball_controller}
class PlungerBallController extends BallController
    with HasGameRef<PinballGame> {
  /// {@macro ball_controller}
  PlungerBallController(Ball<Forge2DGame> ball) : super(ball);

  @override
  void lost() {
    super.lost();
    final bloc = gameRef.read<GameBloc>()..add(const BallLost());
    final shouldBallRespwan = !bloc.state.isLastBall && !bloc.state.isGameOver;

    if (shouldBallRespwan) gameRef.spawnBall();
  }
}
