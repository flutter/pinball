import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class LaunchRampGame extends BasicBallGame {
  LaunchRampGame()
      : super(
          color: Colors.blue,
          ballPriority: Ball.launchRampPriority,
          ballLayer: Layer.launcher,
        );

  static const info = '''
    Shows how LaunchRamp are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera
      ..followVector2(Vector2(0, 0))
      ..zoom = 7.5;

    final launchRamp = LaunchRamp();
    unawaited(addFromBlueprint(launchRamp));

    await traceAllBodies();
  }
}
