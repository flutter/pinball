import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
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
    controller = BonusBallController(this);
  }

  /// [Ball] used in [DebugPinballGame].
  ControlledBall.debug() : super(baseColor: const Color(0xFFFF0000)) {
    controller = BonusBallController(this);
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
abstract class BallController extends ComponentController<Ball> {
  /// {@macro ball_controller}
  BallController(Ball ball) : super(ball);

  /// Removes the [Ball] from a [PinballGame].
  ///
  /// {@template ball_controller_lost}
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  /// {@endtemplate}
  void lost();
}

/// {@template bonus_ball_controller}
/// {@macro ball_controller}
///
/// A [BonusBallController] doesn't change the [GameState.balls] count.
/// {@endtemplate}
class BonusBallController extends BallController {
  /// {@macro bonus_ball_controller}
  BonusBallController(Ball<Forge2DGame> component) : super(component);

  @override
  void lost() {
    component.shouldRemove = true;
  }
}

/// {@template launched_ball_controller}
/// {@macro ball_controller}
///
/// A [LaunchedBallController] changes the [GameState.balls] count.
/// {@endtemplate}
class LaunchedBallController extends BallController
    with HasGameRef<PinballGame>, BlocComponent<GameBloc, GameState> {
  /// {@macro launched_ball_controller}
  LaunchedBallController(Ball<Forge2DGame> ball) : super(ball);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.balls ?? 0) > newState.balls;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    component.shouldRemove = true;
    if (state.balls > 0) gameRef.spawnBall();
  }

  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// {@macro ball_controller_lost}
  @override
  void lost() {
    gameRef.read<GameBloc>().add(const BallLost());
  }
}
