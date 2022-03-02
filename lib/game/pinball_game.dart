import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with KeyboardEvents {
  late Plunger plunger;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final boundaries = createBoundaries(this)..forEach(add);
    final bottomWall = boundaries[2];

    final center = screenToWorld(camera.viewport.effectiveSize / 2);

    await add(plunger = Plunger(Vector2(center.x, center.y - 50)));

    final prismaticJointDef = PrismaticJointDef()
      ..initialize(
        plunger.body,
        bottomWall.body,
        bottomWall.body.position,
        Vector2(0, 0),
      )
      ..localAnchorA.setFrom(Vector2(0, 0))
      ..enableLimit = true
      ..upperTranslation = 0
      ..lowerTranslation = -5
      ..collideConnected = true;

    world.createJoint(prismaticJointDef);
    print(prismaticJointDef.localAnchorA);
    print(prismaticJointDef.localAnchorB);
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
