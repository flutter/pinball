import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AlienBumperAGame extends BasicBallGame {
  AlienBumperAGame() : super(color: const Color(0xFF0000FF));

  static const info = '''
    Shows how a AlienBumperA is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.alienBumper.a.active.keyName,
      Assets.images.alienBumper.a.inactive.keyName,
    ]);

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final alienBumperA = AlienBumper.a()
      ..initialPosition = Vector2(center.x - 20, center.y - 20)
      ..priority = 1;
    await add(alienBumperA);

    await traceAllBodies();
  }
}
