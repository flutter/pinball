import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/ball_booster.dart';
import 'package:sandbox/stories/ball/basic.dart';

void addBallStories(Dashbook dashbook) {
  dashbook.storiesOf('Ball')
    ..add(
      'Basic',
      (context) => GameWidget(
        game: BasicBallGame(
          color: context.colorProperty('color', Colors.blue),
        ),
      ),
      codeLink: buildSourceLink('ball/basic.dart'),
      info: BasicBallGame.info,
    )
    ..add(
      'Booster',
      (context) => GameWidget(
        game: BallBoosterExample(),
      ),
      codeLink: buildSourceLink('ball/ball_booster.dart'),
      info: BallBoosterExample.info,
    );
}
