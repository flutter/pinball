import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BallGame extends AssetsGame with TapDetector, Traceable {
  BallGame({
    Color? color,
    this.ballPriority = 0,
    this.ballLayer = Layer.all,
    this.character,
    List<String>? imagesFileNames,
  }) : super(
          imagesFileNames: [
            Assets.images.ball.ball.keyName,
            Assets.images.ball.androidBall.keyName,
            Assets.images.ball.dashBall.keyName,
            Assets.images.ball.dinoBall.keyName,
            Assets.images.ball.sparkyBall.keyName,
            if (imagesFileNames != null) ...imagesFileNames,
          ],
        );

  static const description = '''
    Shows how a Ball works.
      
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  static final characterBallPaths = <String, String>{
    'Dash': Assets.images.ball.dashBall.keyName,
    'Sparky': Assets.images.ball.sparkyBall.keyName,
    'Android': Assets.images.ball.androidBall.keyName,
    'Dino': Assets.images.ball.dinoBall.keyName,
  };

  final int ballPriority;
  final Layer ballLayer;
  final String? character;

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(
        spriteAsset: characterBallPaths[character],
      )
        ..initialPosition = info.eventPosition.game
        ..layer = ballLayer
        ..priority = ballPriority,
    );
    traceAllBodies();
  }
}
