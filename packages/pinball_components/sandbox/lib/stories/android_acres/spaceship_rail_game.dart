import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SpaceshipRailGame extends BallGame {
  SpaceshipRailGame()
      : super(
          ballPriority: ZIndexes.ballOnSpaceshipRail,
          ballLayer: Layer.spaceshipExitRail,
          imagesFileNames: [
            Assets.images.android.rail.main.keyName,
            Assets.images.android.rail.exit.keyName,
          ],
        );

  static const description = '''
    Shows how SpaceshipRail are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2(-30, -10));
    await add(SpaceshipRail());
    await ready();
    await traceAllBodies();
  }
}
