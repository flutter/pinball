import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

import 'package:sandbox/stories/ball/basic_ball_game.dart';

class FlipperGame extends BasicBallGame with KeyboardEvents, Traceable {
  static const info = '''
    Shows how Flippers are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press left arrow key or "A" to move the left flipper.
    - Press right arrow key or "D" to move the right flipper.
  ''';

  static const _leftFlipperKeys = [
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  ];

  static const _rightFlipperKeys = [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyD,
  ];

  late Flipper leftFlipper;
  late Flipper rightFlipper;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    leftFlipper = Flipper(side: BoardSide.left)
      ..initialPosition = center - Vector2(Flipper.size.x, 0);
    rightFlipper = Flipper(side: BoardSide.right)
      ..initialPosition = center + Vector2(Flipper.size.x, 0);

    await addAll([
      leftFlipper,
      rightFlipper,
    ]);

    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final movedLeftFlipper = _leftFlipperKeys.contains(event.logicalKey);
    if (movedLeftFlipper) {
      if (event is RawKeyDownEvent) {
        leftFlipper.moveUp();
      } else if (event is RawKeyUpEvent) {
        leftFlipper.moveDown();
      }
    }

    final movedRightFlipper = _rightFlipperKeys.contains(event.logicalKey);
    if (movedRightFlipper) {
      if (event is RawKeyDownEvent) {
        rightFlipper.moveUp();
      } else if (event is RawKeyUpEvent) {
        rightFlipper.moveDown();
      }
    }

    return movedLeftFlipper || movedRightFlipper
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }
}
