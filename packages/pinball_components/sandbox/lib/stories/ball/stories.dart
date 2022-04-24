import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/ball_booster_game.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

void addBallStories(Dashbook dashbook) {
  dashbook.storiesOf('Ball')
    ..addGame(
      title: 'Colored',
      description: BallGame.description,
      gameBuilder: (context) => BallGame(
        color: context.colorProperty('color', Colors.blue),
      ),
    )
    ..addGame(
      title: 'Booster',
      description: BallBoosterGame.description,
      gameBuilder: (context) => BallBoosterGame(),
    );
}
