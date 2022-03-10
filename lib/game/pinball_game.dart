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

  late final Plunger plunger;

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

  @override
  Future<void> onLoad() async {
    _addContactCallbacks();

    await _addGameBoundaries();
    unawaited(_addFlippers());
    unawaited(_addPlunger());

    // Corner wall above plunger so the ball deflects into the rest of the
    // board.
    // TODO(allisonryan0002): remove once we have the launch track for the ball.
    await add(
      Wall(
        start: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x,
            100,
          ),
        ),
        end: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x - 100,
            0,
          ),
        ),
      ),
    );
  }

  void spawnBall() {
    add(Ball(position: plunger.body.position));
  }

  void _addContactCallbacks() {
    addContactCallback(BallScorePointsCallback());
    addContactCallback(BottomWallBallContactCallback());
  }

  Future<void> _addGameBoundaries() async {
    await add(BottomWall(this));
    createBoundaries(this).forEach(add);
  }

  Future<void> _addFlippers() async {
    final flippersPosition = screenToWorld(
      Vector2(
        camera.viewport.effectiveSize.x / 2,
        camera.viewport.effectiveSize.y - 120,
      ),
    );
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

  Future<void> _addPlunger() async {
    late PlungerAnchor plungerAnchor;

    await add(
      plunger = Plunger(
        position: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x - 30,
            camera.viewport.effectiveSize.y - Plunger.compressionDistance,
          ),
        ),
      ),
    );
    await add(plungerAnchor = PlungerAnchor(plunger: plunger));

    world.createJoint(
      PlungerAnchorPrismaticJointDef(
        plunger: plunger,
        anchor: plungerAnchor,
      ),
    );
  }
}
