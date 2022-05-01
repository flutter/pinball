import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BallBoosterGame extends LineGame {
  BallBoosterGame()
      : super(
          imagesFileNames: [
            Assets.images.ball.ball.keyName,
            Assets.images.ball.androidBall.keyName,
            Assets.images.ball.dashBall.keyName,
            Assets.images.ball.dinoBall.keyName,
            Assets.images.ball.sparkyBall.keyName,
            Assets.images.ball.flameEffect.keyName,
          ],
        );

  static const description = '''
    Shows how a Ball with a boost works.

    - Drag to launch a boosted Ball.
''';

  @override
  void onLine(Vector2 line) {
    final ball = Ball(baseColor: Colors.transparent);
    add(ball);

    ball.mounted.then((value) => ball.boost(line * -1 * 20));
  }
}
