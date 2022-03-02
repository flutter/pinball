// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template score_points}
/// Specifies the amount of points received on [Ball] collision.
/// {@endtemplate}
mixin ScorePoints {
  /// {@macro score_points}
  int get points;
}

/// [ContactCallback] that adds points to the score when a [Ball] collides with
/// a [BodyComponent] that implements [ScorePoints].
class BallScorePointsCallback extends ContactCallback<Ball, ScorePoints> {
  @override
  void begin(
    Ball ball,
    ScorePoints hasPoints,
    Contact _,
  ) {
    ball.gameRef.read<GameBloc>().add(Scored(points: hasPoints.points));
  }

  // TODO(alestiago): remove if the PR gets merged.
  // https://github.com/flame-engine/flame/pull/1415
  @override
  void end(Ball _, ScorePoints __, Contact ___) {}
}
