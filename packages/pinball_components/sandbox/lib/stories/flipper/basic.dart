import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';

import 'package:sandbox/stories/ball/basic.dart';

class BasicFlipperGame extends BasicBallGame with KeyboardEvents {
  BasicFlipperGame() : super(color: Colors.blue);

  static const info = '''
      Basic example of how a Flipper works.
''';

  static final _leftFlipperKeys = {
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  };

  static final _rightFlipperKeys = {
    LogicalKeyboardKey.arrowRight,
  };

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
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final movedLeftFlipper =
        _leftFlipperKeys.intersection(keysPressed).isNotEmpty;
    if (event is RawKeyDownEvent && movedLeftFlipper) {
      leftFlipper.moveUp();
    } else if (event is RawKeyUpEvent && movedLeftFlipper) {
      leftFlipper.moveDown();
    }

    final movedRightFlipper =
        _rightFlipperKeys.intersection(keysPressed).isNotEmpty;
    if (event is RawKeyDownEvent && movedRightFlipper) {
      rightFlipper.moveUp();
    } else if (event is RawKeyUpEvent && movedRightFlipper) {
      rightFlipper.moveDown();
    }

    return movedLeftFlipper || movedRightFlipper
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }
}
