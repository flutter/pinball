import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BallGame extends AssetsGame with TapDetector, Traceable {
  BallGame({
    this.color = Colors.blue,
    this.ballPriority = 0,
    this.ballLayer = Layer.all,
    List<String>? imagesFileNames,
  }) : super(
          imagesFileNames: [
            Assets.images.ball.ball.keyName,
            if (imagesFileNames != null) ...imagesFileNames,
          ],
        );

  static const description = '''
    Shows how a Ball works.
      
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final Color color;
  final int ballPriority;
  final Layer ballLayer;

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(baseColor: color)
        ..initialPosition = info.eventPosition.game
        ..layer = ballLayer
        ..priority = ballPriority,
    );
    traceAllBodies();
  }
}
