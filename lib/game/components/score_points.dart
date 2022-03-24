// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template score_points}
/// Specifies the amount of points received on [Ball] collision.
/// {@endtemplate}
mixin ScorePoints<T extends Forge2DGame> on BodyComponent<T> {
  /// {@macro score_points}
  int get points;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body.userData = this;
  }
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
}
