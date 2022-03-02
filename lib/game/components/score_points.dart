// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template score_points}
/// Specifies the amount of points received on [Ball] collision.
/// {@endtemplate}
mixin ScorePoints on BodyComponent {
  /// {@macro score_points}
  int get points;
}

/// Adds points to the score when a [Ball] collides with a [BodyComponent] that
/// implements [ScorePoints].
class BallScorePointsCallback extends ContactCallback<Ball, ScorePoints> {
  @override
  void begin(
    Ball ball,
    ScorePoints scorePoints,
    Contact _,
  ) {
    ball.gameRef.read<GameBloc>().add(Scored(points: scorePoints.points));
  }

  // TODO(alestiago): remove once this issue is closed.
  // https://github.com/flame-engine/flame/issues/1414
  @override
  void end(Ball _, ScorePoints __, Contact ___) {}
}
