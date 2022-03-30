import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template controlled_ball}
/// A [Ball] with a [BallController] attached.
/// {@endtemplate}
class ControlledBall extends Ball with Controls<BallController> {
  /// A [Ball] that starts at the [Plunger].
  ///
  /// When a launched [Ball] is lost, it will decrease the [GameState.balls]
  /// count, and a new [Ball] is spawned at the [Plunger].
  ControlledBall.launch({
    required PinballTheme theme,
    required Plunger plunger,
  }) : super(baseColor: theme.characterTheme.ballColor) {
    initialPosition = Vector2(
      plunger.body.position.x,
      plunger.body.position.y + Ball.size.y,
    );
    controller = LaunchedBallController(this);
  }

  /// {@template bonus_ball}
  /// {@macro controlled_ball}
  ///
  /// When a bonus [Ball] is lost, the [GameState.balls] doesn't change.
  /// {@endtemplate}
  ControlledBall.bonus({
    required PinballTheme theme,
  }) : super(baseColor: theme.characterTheme.ballColor) {
    controller = BallController(this);
  }

  /// [Ball] used in [DebugPinballGame].
  ControlledBall.debug() : super(baseColor: const Color(0xFFFF0000)) {
    controller = BallController(this);
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends ComponentController<Ball> {
  /// {@macro ball_controller}
  BallController(Ball ball) : super(ball);

  /// Removes the [Ball] from a [PinballGame].
  ///
  /// {@template ball_controller_lost}
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  /// {@endtemplate}
  void lost() {
    component.shouldRemove = true;
  }
}

/// {@macro ball_controller}
class LaunchedBallController extends BallController
    with HasGameRef<PinballGame> {
  /// {@macro ball_controller}
  LaunchedBallController(Ball<Forge2DGame> ball) : super(ball);

  @override

  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// {@macro ball_controller_lost}
  void lost() {
    super.lost();
    final bloc = gameRef.read<GameBloc>()..add(const BallLost());
    final shouldBallRespwan = !bloc.state.isLastBall && !bloc.state.isGameOver;

    if (shouldBallRespwan) gameRef.spawnBall();
  }
}
