import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with FlameBloc, KeyboardEvents {
  late final Flipper _rightFlipper;
  late final Flipper _leftFlipper;
  late final RevoluteJoint _leftFlipperRevoluteJoint;
  late final RevoluteJoint _rightFlipperRevoluteJoint;

  void spawnBall() {
    add(Ball(position: ballStartingPosition));
  }

  // TODO(erickzanardo): Change to the plumber position
  late final ballStartingPosition = screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y - 20,
        ),
      ) -
      Vector2(0, -20);

  // TODO(alestiago): Change to the design position.
  late final flippersPosition = ballStartingPosition - Vector2(0, 5);

  Future<void> _addFlippers() async {
    const spaceBetweenFlippers = 2;
    await add(
      _leftFlipper = Flipper(
        position: Vector2(
          flippersPosition.x - (Flipper.width / 2) - (spaceBetweenFlippers / 2),
          flippersPosition.y,
        ),
        side: BoardSide.left,
      ),
    );
    final leftFlipperAnchor = FlipperAnchor(flipper: _leftFlipper);
    await add(leftFlipperAnchor);
    final leftFlipperRevoluteJointDef = FlipperAnchorRevoluteJointDef(
      flipper: _leftFlipper,
      anchor: leftFlipperAnchor,
    );
    // TODO(alestiago): Remove casting once the following is closed:
    // https://github.com/flame-engine/forge2d/issues/36
    _leftFlipperRevoluteJoint =
        world.createJoint(leftFlipperRevoluteJointDef) as RevoluteJoint;

    await add(
      _rightFlipper = Flipper(
        position: Vector2(
          flippersPosition.x + (Flipper.width / 2) + (spaceBetweenFlippers / 2),
          flippersPosition.y,
        ),
        side: BoardSide.right,
      ),
    );
    final rightFlipperAnchor = FlipperAnchor(flipper: _rightFlipper);
    await add(rightFlipperAnchor);
    final rightFlipperRevoluteJointDef = FlipperAnchorRevoluteJointDef(
      flipper: _rightFlipper,
      anchor: rightFlipperAnchor,
    );
    // TODO(alestiago): Remove casting once the following is closed:
    // https://github.com/flame-engine/forge2d/issues/36
    _rightFlipperRevoluteJoint =
        world.createJoint(rightFlipperRevoluteJointDef) as RevoluteJoint;
  }

  @override
  Future<void> onLoad() async {
    addContactCallback(BallScorePointsCallback());

    await add(BottomWall(this));
    addContactCallback(BottomWallBallContactCallback());

    await _addFlippers();
  }

  @override
  Future<void> onMount() async {
    super.onMount();
    // TODO(erickzanardo): Clean this once the issue is solved:
    // https://github.com/flame-engine/flame/issues/1417
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _leftFlipper.hasMounted.future;
    await _rightFlipper.hasMounted.future;

    FlipperAnchorRevoluteJointDef.unlock(
      _leftFlipperRevoluteJoint,
      BoardSide.left,
    );
    FlipperAnchorRevoluteJointDef.unlock(
      _rightFlipperRevoluteJoint,
      BoardSide.right,
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent &&
        (event.data.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.data.logicalKey == LogicalKeyboardKey.keyA)) {
      _leftFlipper.moveUp();
    }

    if (event is RawKeyUpEvent &&
        (event.data.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.data.logicalKey == LogicalKeyboardKey.keyA)) {
      _leftFlipper.moveDown();
    }

    if (event is RawKeyDownEvent &&
        (event.data.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.data.logicalKey == LogicalKeyboardKey.keyA)) {
      _leftFlipper.moveUp();
    }

    if (event is RawKeyUpEvent &&
        (event.data.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.data.logicalKey == LogicalKeyboardKey.keyD)) {
      _rightFlipper.moveDown();
    }

    if (event is RawKeyDownEvent &&
        (event.data.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.data.logicalKey == LogicalKeyboardKey.keyD)) {
      _rightFlipper.moveUp();
    }

    return KeyEventResult.handled;
  }

  @override
  void onAttach() {
    super.onAttach();
    spawnBall();
  }
}
