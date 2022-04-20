import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SparkyBumperGame extends BasicBallGame with Traceable {
  static const info = '''
    Shows how a SparkyBumper is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await Future.wait([
      images.load(Assets.images.sparky.bumper.a.on.keyName),
      images.load(Assets.images.sparky.bumper.a.off.keyName),
      images.load(Assets.images.sparky.bumper.b.on.keyName),
      images.load(Assets.images.sparky.bumper.b.off.keyName),
      images.load(Assets.images.sparky.bumper.c.on.keyName),
      images.load(Assets.images.sparky.bumper.c.off.keyName),
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
