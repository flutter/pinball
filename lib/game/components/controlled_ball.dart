import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template controlled_ball}
/// A [Ball] with a [BallController] attached.
/// {@endtemplate}
class ControlledBall extends Ball with Controls<BallController> {
  /// A [Ball] that launches from the [Plunger].
  ///
  /// When a launched [Ball] is lost, it will decrease the [GameState.balls]
  /// count, and a new [Ball] is spawned.
  ControlledBall.launch({
    required PinballTheme theme,
  }) : super(baseColor: theme.characterTheme.ballColor) {
    controller = BallController(this);
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
    controller = _DebugBallController(this);
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends ComponentController<Ball>
    with HasGameRef<PinballGame> {
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
    gameRef.read<GameBloc>().add(const BallLost());
  }
}

class _DebugBallController extends BallController {
  _DebugBallController(Ball<Forge2DGame> component) : super(component);

  @override
  void lost() {
    component.shouldRemove = true;
  }
}
