import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SparkyComputerGame extends BallGame {
  static const description = '''
    Shows how the SparkyComputer is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.sparky.computer.base.keyName,
      Assets.images.sparky.computer.top.keyName,
      Assets.images.sparky.computer.glow.keyName,
    ]);

    camera.followVector2(Vector2(-10, -40));
    await add(SparkyComputer());
    await ready();
    await traceAllBodies();
  }
}
