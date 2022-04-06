import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AlienBumperGame extends BasicBallGame {
  AlienBumperGame({
    required this.trace,
  }) : super(color: const Color(0xFF0000FF));

  static const info = '''
    Shows how a AlienBumper is rendered.

    Activate the "trace" parameter to overlay the body.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final alienBumperA = AlienBumper.a()
      ..initialPosition = Vector2(center.x - 20, center.y - 20)
      ..priority = 1;
    final alienBumperB = AlienBumper.b()
      ..initialPosition = Vector2(center.x - 10, center.y + 10)
      ..priority = 1;
    await addAll([
      alienBumperA,
      alienBumperB,
    ]);

    if (trace) {
      alienBumperA.trace();
      alienBumperB.trace();
    }
  }
}
