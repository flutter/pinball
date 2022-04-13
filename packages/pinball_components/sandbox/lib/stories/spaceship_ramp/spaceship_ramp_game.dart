import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SpaceshipRampGame extends BasicBallGame {
  SpaceshipRampGame()
      : super(
          color: Colors.blue,
          ballPriority: Ball.spaceshipRampPriority,
          ballLayer: Layer.spaceshipEntranceRamp,
        );

  static const info = '''
    Shows how SpaceshipRamp is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addFromBlueprint(SpaceshipRamp());
    camera.followVector2(Vector2(-12, -50));
    await traceAllBodies();
  }
}
