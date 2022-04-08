import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class PlungerGame extends BasicBallGame with KeyboardEvents, Traceable {
  PlungerGame() : super(color: const Color(0xFFFF0000));

  static const info = '''
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

    plunger = Plunger(compressionDistance: 29)
      ..initialPosition = Vector2(center.x - (Kicker.size.x * 2), center.y);
    await add(plunger);

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
