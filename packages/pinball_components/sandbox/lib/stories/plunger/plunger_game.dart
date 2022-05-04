import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class PlungerGame extends BallGame with KeyboardEvents, Traceable {
  static const description = '''
    Shows how Plunger is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  static const _downKeys = [
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.space,
  ];

  late Plunger plunger;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    await add(
      plunger = Plunger(compressionDistance: 29)
        ..initialPosition = Vector2(center.x - 8.8, center.y),
    );
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final movedPlungerDown = _downKeys.contains(event.logicalKey);
    if (movedPlungerDown) {
      if (event is RawKeyDownEvent) {
        plunger.pull();
      } else if (event is RawKeyUpEvent) {
        plunger.release();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
