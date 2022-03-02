// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

mixin ScorePoints {
  int get points;
}

class BallScorePointsCallback extends ContactCallback<Ball, ScorePoints> {
  @override
  void begin(
    Ball ball,
    ScorePoints hasPoints,
    Contact _,
  ) {
    ball.gameRef.read<GameBloc>().add(Scored(points: hasPoints.points));
  }

  @override
  void end(Ball _, ScorePoints __, Contact ___) {}
}
