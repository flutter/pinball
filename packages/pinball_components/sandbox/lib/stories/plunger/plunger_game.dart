import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class PlungerGame extends BasicBallGame with HasKeyboardHandlerComponents {
  PlungerGame({
    required this.trace,
  }) : super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how Plunger is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    final plunger = Plunger(compressionDistance: 29)
      ..initialPosition = Vector2(center.x - (Kicker.size.x * 2), center.y);
    await add(plunger);

    if (trace) plunger.trace();
  }
}
