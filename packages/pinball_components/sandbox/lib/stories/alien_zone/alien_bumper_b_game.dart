import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AlienBumperBGame extends BasicBallGame {
  AlienBumperBGame() : super(color: const Color(0xFF0000FF));

  static const info = '''
    Shows how a AlienBumperB is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final alienBumperB = AlienBumper.b()
      ..initialPosition = Vector2(center.x - 10, center.y + 10)
      ..priority = 1;
    await add(alienBumperB);

    await traceAllBodies();
  }
}
