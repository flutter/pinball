// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

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

/// {@template ball_score_points_callbacks}
/// Adds points to the score when a [Ball] collides with a [BodyComponent] that
/// implements [ScorePoints].
/// {@endtemplate}
class BallScorePointsCallback extends ContactCallback<Ball, ScorePoints> {
  /// {@macro ball_score_points_callbacks}
  BallScorePointsCallback(PinballGame game) : _gameRef = game;

  final PinballGame _gameRef;

  @override
  void begin(
    Ball _,
    ScorePoints scorePoints,
    Contact __,
  ) {
    _gameRef.read<GameBloc>().add(
          Scored(points: scorePoints.points),
        );

    _gameRef.audio.score();
  }
}
