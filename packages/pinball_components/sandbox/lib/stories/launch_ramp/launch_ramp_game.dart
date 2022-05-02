import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class LaunchRampGame extends BallGame {
  LaunchRampGame()
      : super(
          ballPriority: ZIndexes.ballOnLaunchRamp,
          ballLayer: Layer.launcher,
        );

  static const description = '''
    Shows how the LaunchRamp is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera
      ..followVector2(Vector2.zero())
      ..zoom = 7.5;
    await add(LaunchRamp());
    await ready();
    await traceAllBodies();
  }
}
