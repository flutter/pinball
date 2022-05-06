// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
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
  }) : super(assetPath: characterTheme.ball.keyName) {
    controller = BallController(this);
    layer = Layer.launcher;
    zIndex = ZIndexes.ballOnLaunchRamp;
  }

  /// {@macro controlled_ball}
  ControlledBall.bonus({
    required CharacterTheme characterTheme,
  }) : super(assetPath: characterTheme.ball.keyName) {
    controller = BallController(this);
    zIndex = ZIndexes.ballOnBoard;
  }

  /// [Ball] used in [DebugPinballGame].
  ControlledBall.debug() : super() {
    controller = BallController(this);
    zIndex = ZIndexes.ballOnBoard;
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends ComponentController<Ball>
    with FlameBlocReader<GameBloc, GameState> {
  /// {@macro ball_controller}
  BallController(Ball ball) : super(ball);

  /// Stops the [Ball] inside of the [SparkyComputer] while the turbo charge
  /// sequence runs, then boosts the ball out of the computer.
  Future<void> turboCharge() async {
    bloc.add(const SparkyTurboChargeActivated());

    component.stop();
    // TODO(alestiago): Refactor this hard coded duration once the following is
    // merged:
    // https://github.com/flame-engine/flame/pull/1564
    await Future<void>.delayed(
      const Duration(milliseconds: 2583),
    );
    component.resume();
    await component.add(
      BallTurboChargingBehavior(impulse: Vector2(40, 110)),
    );
  }
}
