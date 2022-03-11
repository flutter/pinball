// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGame extends Forge2DGame
    with FlameBloc, HasKeyboardHandlerComponents {
  PinballGame({required this.theme});

  final PinballTheme theme;

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

  @override
  void onAttach() {
    super.onAttach();
    spawnBall();
  }

  void spawnBall() {
    add(Ball(position: ballStartingPosition));
  }

  @override
  Future<void> onLoad() async {
    addContactCallback(BallScorePointsCallback());

    await add(BottomWall(this));
    addContactCallback(BottomWallBallContactCallback());

    unawaited(_addFlippers());

    await _addBaseboards();
  }

  Future<void> _addFlippers() async {
    const spaceBetweenFlippers = 2;
    final leftFlipper = Flipper.left(
      position: Vector2(
        flippersPosition.x - (Flipper.width / 2) - (spaceBetweenFlippers / 2),
        flippersPosition.y,
      ),
    );
    await add(leftFlipper);
    final leftFlipperAnchor = FlipperAnchor(flipper: leftFlipper);
    await add(leftFlipperAnchor);
    final leftFlipperRevoluteJointDef = FlipperAnchorRevoluteJointDef(
      flipper: leftFlipper,
      anchor: leftFlipperAnchor,
    );
    // TODO(alestiago): Remove casting once the following is closed:
    // https://github.com/flame-engine/forge2d/issues/36
    final leftFlipperRevoluteJoint =
        world.createJoint(leftFlipperRevoluteJointDef) as RevoluteJoint;

    final rightFlipper = Flipper.right(
      position: Vector2(
        flippersPosition.x + (Flipper.width / 2) + (spaceBetweenFlippers / 2),
        flippersPosition.y,
      ),
    );
    await add(rightFlipper);
    final rightFlipperAnchor = FlipperAnchor(flipper: rightFlipper);
    await add(rightFlipperAnchor);
    final rightFlipperRevoluteJointDef = FlipperAnchorRevoluteJointDef(
      flipper: rightFlipper,
      anchor: rightFlipperAnchor,
    );
    // TODO(alestiago): Remove casting once the following is closed:
    // https://github.com/flame-engine/forge2d/issues/36
    final rightFlipperRevoluteJoint =
        world.createJoint(rightFlipperRevoluteJointDef) as RevoluteJoint;

    // TODO(erickzanardo): Clean this once the issue is solved:
    // https://github.com/flame-engine/flame/issues/1417
    // FIXME(erickzanardo): when mounted the initial position is not fully
    // reached.
    unawaited(
      leftFlipper.hasMounted.future.whenComplete(
        () => FlipperAnchorRevoluteJointDef.unlock(
          leftFlipperRevoluteJoint,
          leftFlipper.side,
        ),
      ),
    );
    unawaited(
      rightFlipper.hasMounted.future.whenComplete(
        () => FlipperAnchorRevoluteJointDef.unlock(
          rightFlipperRevoluteJoint,
          rightFlipper.side,
        ),
      ),
    );
  }

  Future<void> _addBaseboards() async {
    final spaceBetweenBaseboards = camera.viewport.effectiveSize.x / 2;

    final leftBaseboard = Baseboard.left(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 - (spaceBetweenBaseboards / 2),
          camera.viewport.effectiveSize.y / 1.17,
        ),
      ),
    );
    await add(leftBaseboard);

    final rightBaseboard = Baseboard.right(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 + (spaceBetweenBaseboards / 2),
          camera.viewport.effectiveSize.y / 1.17,
        ),
      ),
    );
    await add(rightBaseboard);
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  void onTapUp(TapUpInfo info) {
    add(Ball(position: info.eventPosition.game));
  }
}
