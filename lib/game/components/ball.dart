import 'package:flame/components.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ball_type}
/// Specifies the type of [Ball].
///
/// Different [BallType]s are affected by different game mechanics.
/// {@endtemplate}
enum BallType {
  /// A [Ball] spawned from the [Plunger].
  ///
  /// [normal] balls decrease the [GameState.balls] when they fall through the
  /// the [BottomWall].
  normal,

  /// A [Ball] that does not alter [GameState.balls].
  ///
  /// For example, a [Ball] spawned by Dash in the [FlutterForest].
  extra,
}

/// {@template ball_blueprint}
/// [Blueprint] which cretes a ball game object.
/// {@endtemplate}
class BallBlueprint extends Blueprint<PinballGame> {
  /// {@macro ball_blueprint}
  BallBlueprint({
    required this.position,
    required this.type,
  });

  /// The initial position of the [Ball].
  final Vector2 position;

  /// {@macro ball_type}
  final BallType type;

  @override
  void build(PinballGame gameRef) {
    final baseColor = gameRef.theme.characterTheme.ballColor;
    final ball = Ball(baseColor: baseColor)
      ..add(
        BallController(type: type),
      );

    add(ball..initialPosition = position + Vector2(0, ball.size.y / 2));
  }
}

/// {@template ball_controller}
/// Controller attached to a [Ball] that handles its game related logic.
/// {@endtemplate}
class BallController extends Component with HasGameRef<PinballGame> {
  /// {@macro ball_controller}
  BallController({required this.type});

  /// {@macro ball_type}
  final BallType type;

  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  void lost() {
    parent?.shouldRemove = true;
    // TODO(alestiago): Consider adding test for this logic once we remove the
    // BallX extension.
    if (type != BallType.normal) return;

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
