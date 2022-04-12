import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SpaceshipRailGame extends BasicBallGame {
  SpaceshipRailGame()
      : super(
          color: Colors.blue,
          ballPriority: Ball.spaceshipRailPriority,
          ballLayer: Layer.spaceshipExitRail,
        );

  static const info = '''
    Shows how SpaceshipRail are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2(-30, -10));

    final spaceshipRail = SpaceshipRail();
    unawaited(addFromBlueprint(spaceshipRail));

    await traceAllBodies();
  }
}
