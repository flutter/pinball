import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

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
