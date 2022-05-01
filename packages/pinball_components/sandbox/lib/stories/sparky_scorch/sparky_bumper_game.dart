import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SparkyBumperGame extends BallGame {
  static const description = '''
    Shows how a SparkyBumper is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.sparky.bumper.a.lit.keyName,
      Assets.images.sparky.bumper.a.dimmed.keyName,
      Assets.images.sparky.bumper.b.lit.keyName,
      Assets.images.sparky.bumper.b.dimmed.keyName,
      Assets.images.sparky.bumper.c.lit.keyName,
      Assets.images.sparky.bumper.c.dimmed.keyName,
    ]);

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final sparkyBumperA = SparkyBumper.a()
      ..initialPosition = Vector2(center.x - 20, center.y + 20)
      ..priority = 1;
    final sparkyBumperB = SparkyBumper.b()
      ..initialPosition = Vector2(center.x - 10, center.y - 10)
      ..priority = 1;
    final sparkyBumperC = SparkyBumper.c()
      ..initialPosition = Vector2(center.x + 20, center.y)
      ..priority = 1;
    await addAll([
      sparkyBumperA,
      sparkyBumperB,
      sparkyBumperC,
    ]);

    await traceAllBodies();
  }
}
