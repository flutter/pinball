import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with FlameBloc, KeyboardEvents {
  late Plunger plunger;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addContactCallback(BallScorePointsCallback());

    final boundaries = createBoundaries(this)..forEach(add);
    final bottomWall = boundaries[2];

    final center = screenToWorld(camera.viewport.effectiveSize / 2);

    await add(plunger = Plunger(Vector2(center.x, center.y)));

    world.createJoint(
      PlungerAnchorPrismaticJointDef(plunger: plunger, anchor: bottomWall),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyUpEvent &&
        event.data.logicalKey == LogicalKeyboardKey.space) {
      plunger.release();
    }
    if (event is RawKeyDownEvent &&
        event.data.logicalKey == LogicalKeyboardKey.space) {
      plunger.pull();
    }
    return KeyEventResult.handled;
  }
}
