import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class LaunchRampGame extends BallGame {
  LaunchRampGame()
      : super(
          color: Colors.blue,
          ballPriority: RenderPriority.ballOnLaunchRamp,
          ballLayer: Layer.launcher,
        );

  static const description = '''
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
