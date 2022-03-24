import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ball_blueprint}
/// [Blueprint] which cretes a ball game object
/// {@endtemplate}
class BallBlueprint extends Blueprint<PinballGame> {
  /// {@macro ball_blueprint}
  BallBlueprint({required this.position});

  /// The initial position of the [Ball]
  final Vector2 position;

  @override
  void build(PinballGame gameRef) {
    final baseColor = gameRef.theme.characterTheme.ballColor;
    final ball = Ball(baseColor: baseColor)..add(BallController());

    add(ball..initialPosition = position + Vector2(0, ball.size.y / 2));
  }
}

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces along the
/// [PinballGame].
/// {@endtemplate}
class BallController extends Component with HasGameRef<PinballGame> {
  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  void lost() {
    parent?.shouldRemove = true;

    final bloc = gameRef.read<GameBloc>()..add(const BallLost());

    final shouldBallRespwan = !bloc.state.isLastBall && !bloc.state.isGameOver;
    if (shouldBallRespwan) {
      gameRef.spawnBall();
    }
  }
}

/// Adds helper methods to the [Ball]
extension BallX on Ball {
  /// Returns the controller instance of the ball
  // TODO(erickzanardo): Remove the need of an extension.
  BallController get controller {
    return children.whereType<BallController>().first;
  }
}
