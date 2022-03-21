import 'dart:async';
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// {@template chrome_dino}
/// Dinosour that gobbles up a [Ball], swivel his head around, and shoots it
/// back out.
/// {@endtemplate}
class ChromeDino extends BodyComponent with InitialPosition {
  /// {@macro chrome_dino}
  ChromeDino() {
    // TODO(alestiago): Remove once sprites are defined.
    paint = Paint()..color = Colors.blue;
  }

  static final size = Vector2(3, 1);

  /// Anchors the [ChromeDino] to the [RevoluteJoint] that controls its arc
  /// motion.
  Future<void> _anchorToJoint() async {
    final anchor = ChromeDinoAnchor(chromeDino: this);
    await add(anchor);

    final jointDef = ChromeDinoAnchorRevoluteJointDef(
      chromeDino: this,
      anchor: anchor,
    );
    final joint = world.createJoint(jointDef) as RevoluteJoint;

    ChromeDinoAnchorRevoluteJointDef.spin(joint, removed);
  }

  Completer removed = Completer<bool>();

  @override
  void onRemove() {
    super.onRemove();
    removed.complete(true);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _anchorToJoint();
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(size.x, size.y);
    final fixtureDef = FixtureDef(shape)..density = 1;

    final bodyDef = BodyDef()
      ..gravityScale = 0
      ..position = initialPosition
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template flipper_anchor}
/// [JointAnchor] positioned at the end of a [ChromeDino].
/// {@endtemplate}
class ChromeDinoAnchor extends JointAnchor {
  /// {@macro flipper_anchor}
  ChromeDinoAnchor({
    required ChromeDino chromeDino,
  }) {
    initialPosition = Vector2(
      chromeDino.body.position.x + ChromeDino.size.x / 2,
      chromeDino.body.position.y,
    );
  }
}

/// {@template chrome_dino_anchor_revolute_joint_def}
/// Hinges a [ChromeDino] to a [ChromeDinoAnchor].
/// {@endtemplate}
class ChromeDinoAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro chrome_dino_anchor_revolute_joint_def}
  ChromeDinoAnchorRevoluteJointDef({
    required ChromeDino chromeDino,
    required ChromeDinoAnchor anchor,
  }) {
    initialize(
      chromeDino.body,
      anchor.body,
      anchor.body.position,
    );
    enableLimit = true;
    const halfAngle = _sweepingAngle / 2;
    lowerAngle = -halfAngle;
    upperAngle = halfAngle;

    enableMotor = true;
    maxMotorTorque = 999;
    motorSpeed = 999;
  }

  // TODO(alestiago): Refactor.
  static void spin(RevoluteJoint joint, Completer completer) {
    Future.doWhile(() async {
      if (completer.isCompleted) return false;

      await Future<void>.delayed(Duration(milliseconds: 1000));
      joint.setMotorSpeed(-joint.motorSpeed);
      return true;
    });
  }

  /// The total angle of the arc motion.
  static const _sweepingAngle = math.pi / 3.5;
}
