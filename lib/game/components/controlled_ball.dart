import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template controlled_ball}
/// A [Ball] with a [BallController] attached.
///
/// When a [Ball] is lost, if there aren't more [Ball]s in play and the game is
/// not over, a new [Ball] will be spawned.
/// {@endtemplate}
class ControlledBall extends Ball with Controls<BallController> {
  /// A [Ball] that launches from the [Plunger].
  ControlledBall.launch({
    required CharacterTheme characterTheme,
  }) : super(baseColor: characterTheme.ballColor) {
    controller = BallController(this);
    priority = RenderPriority.ballOnLaunchRamp;
    layer = Layer.launcher;
  }

  /// {@template bonus_ball}
  /// {@macro controlled_ball}
  /// {@endtemplate}
  ControlledBall.bonus({
    required CharacterTheme characterTheme,
  }) : super(baseColor: characterTheme.ballColor) {
    controller = BallController(this);
    priority = RenderPriority.ballOnBoard;
  }

  /// [Ball] used in [DebugPinballGame].
  ControlledBall.debug() : super(baseColor: const Color(0xFFFF0000)) {
    controller = BallController(this);
    priority = RenderPriority.ballOnBoard;
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends ComponentController<Ball>
    with HasGameRef<PinballGame> {
  /// {@macro ball_controller}
  BallController(Ball ball) : super(ball);

  /// Event triggered when the ball is lost.
  // TODO(alestiago): Refactor using behaviors.
  void lost() {
    component.shouldRemove = true;
  }

  /// Stops the [Ball] inside of the [SparkyComputer] while the turbo charge
  /// sequence runs, then boosts the ball out of the computer.
  Future<void> turboCharge() async {
    gameRef.read<GameBloc>().add(const SparkyTurboChargeActivated());

    component.stop();
    // TODO(alestiago): Refactor this hard coded duration once the following is
    // merged:
    // https://github.com/flame-engine/flame/pull/1564
    await Future<void>.delayed(
      const Duration(milliseconds: 2583),
    );
    component.resume();
    await component.boost(Vector2(40, 110));
  }

  @override
  void onRemove() {
    super.onRemove();
    final noBallsLeft = gameRef.descendants().whereType<Ball>().isEmpty;
    if (noBallsLeft) {
      gameRef.read<GameBloc>().add(const RoundLost());
    }
  }
}
