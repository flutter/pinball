import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with FlameBloc, KeyboardEvents {
  late Plunger plunger;
  late PrismaticJointDef prismaticJointDef;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addContactCallback(BallScorePointsCallback());

    final boundaries = createBoundaries(this)..forEach(add);
    final bottomWall = boundaries[2];

    final center = screenToWorld(camera.viewport.effectiveSize / 2);

    await add(plunger = Plunger(Vector2(center.x, center.y - 50)));

    prismaticJointDef = PrismaticJointDef()
      ..initialize(
        plunger.body,
        bottomWall.body,
        plunger.body.position,
        // Logically, I feel like this should be (0, 1), but it has to be
        // negative for lowerTranslation limit to work as expected.
        Vector2(0, -1),
      )
      ..enableLimit = true
      // Given the above inverted vertical axis, the lowerTranslation works as
      // expected and this lets the plunger fall down 10 units before being
      // stopped.
      //
      // Ideally, we shouldn't need to set any limits here - this is just for
      // demo purposes to see how the limits work. We should be leaving this at
      // 0 and altering it as the user holds the space bar. The longer they hold
      // it, the lower the lowerTranslation becomes - allowing the plunger to
      // slowly fall down (see key event handlers below).
      ..lowerTranslation = -10
      // This prevents the plunger from falling through the bottom wall.
      ..collideConnected = true;

    world.createJoint(prismaticJointDef);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyUpEvent &&
        event.data.logicalKey == LogicalKeyboardKey.space) {
      // I haven't been able to successfully pull down the plunger, so this is
      // completely untested. I imagine we could calculate the distance between
      // the prismaticJoinDef.upperTranslation (plunger starting position) and
      // the ground, then use that value as a multiplier on the speed so the
      // ball moves faster when you pull the plunger farther down.
      prismaticJointDef.motorSpeed = 5;
    }
    if (event is RawKeyDownEvent &&
        event.data.logicalKey == LogicalKeyboardKey.space) {
      // This was my attempt to decrement the lower limit but it doesn't seem to
      // render. If you debug, you can see that this value is being lowered,
      // but the game isn't reflecting these value changes.
      prismaticJointDef.lowerTranslation--;
    }
    return KeyEventResult.handled;
  }
}
