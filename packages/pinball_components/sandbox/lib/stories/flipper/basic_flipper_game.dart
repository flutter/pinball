import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BasicFlipperGame extends BasicBallGame with KeyboardEvents {
  BasicFlipperGame({
    required this.trace,
  }) : super(color: Colors.blue);

  static const info = 'Shows how a Flipper works.';

  static const _leftFlipperKeys = [
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  ];

  static const _rightFlipperKeys = [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyD,
  ];

  final bool trace;

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

    if (trace) {
      leftFlipper.trace();
      rightFlipper.trace();
    }
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
