import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template chrome_dino}
/// Dinosaur that gobbles up a [Ball], swivel his head around, and shoots it
/// back out.
/// {@endtemplate}
class ChromeDino extends BodyComponent with InitialPosition {
  /// {@macro chrome_dino}
  ChromeDino() {
    // TODO(alestiago): Remove once sprites are defined.
    paint = Paint()..color = Colors.blue;
  }

  /// The size of the dinosaur mouth.
  static final size = Vector2(5, 2.5);

  /// Anchors the [ChromeDino] to the [RevoluteJoint] that controls its arc
  /// motion.
  Future<_ChromeDinoJoint> _anchorToJoint() async {
    final anchor = _ChromeDinoAnchor();
    await add(anchor);

    final jointDef = _ChromeDinoAnchorRevoluteJointDef(
      chromeDino: this,
      anchor: anchor,
    );
    final joint = _ChromeDinoJoint(jointDef);
    world.createJoint(joint);

    return joint;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final joint = await _anchorToJoint();
    await add(
      TimerComponent(
        period: 1,
        onTick: joint._swivel,
        repeat: true,
      ),
    );
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixtureDefs = <FixtureDef>[];

    // TODO(alestiago): Subject to change when sprites are added.
    final box = PolygonShape()..setAsBoxXY(size.x / 2, size.y / 2);
    final fixtureDef = FixtureDef(box)
      ..shape = box
      ..density = 999
      ..friction = 0.3
      ..restitution = 0.1
      ..isSensor = true;
    fixtureDefs.add(fixtureDef);

    // FIXME(alestiago): Investigate why adding these fixtures is considered as
    // an invalid contact type.
    // final upperEdge = EdgeShape()
    //   ..set(
    //     Vector2(-size.x / 2, -size.y / 2),
    //     Vector2(size.x / 2, -size.y / 2),
    //   );
    // final upperEdgeDef = FixtureDef(upperEdge)..density = 0.5;
    // fixtureDefs.add(upperEdgeDef);

    // final lowerEdge = EdgeShape()
    //   ..set(
    //     Vector2(-size.x / 2, size.y / 2),
    //     Vector2(size.x / 2, size.y / 2),
    //   );
    // final lowerEdgeDef = FixtureDef(lowerEdge)..density = 0.5;
    // fixtureDefs.add(lowerEdgeDef);

    // final rightEdge = EdgeShape()
    //   ..set(
    //     Vector2(size.x / 2, -size.y / 2),
    //     Vector2(size.x / 2, size.y / 2),
    //   );
    // final rightEdgeDef = FixtureDef(rightEdge)..density = 0.5;
    // fixtureDefs.add(rightEdgeDef);

    return fixtureDefs;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..gravityScale = 0
      ..position = initialPosition
      ..type = BodyType.dynamic;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

/// {@template flipper_anchor}
/// [JointAnchor] positioned at the end of a [ChromeDino].
/// {@endtemplate}
class _ChromeDinoAnchor extends JointAnchor {
  /// {@macro flipper_anchor}
  _ChromeDinoAnchor() {
    initialPosition = Vector2(
      ChromeDino.size.x / 2,
      0,
    );
  }
}

/// {@template chrome_dino_anchor_revolute_joint_def}
/// Hinges a [ChromeDino] to a [_ChromeDinoAnchor].
/// {@endtemplate}
class _ChromeDinoAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro chrome_dino_anchor_revolute_joint_def}
  _ChromeDinoAnchorRevoluteJointDef({
    required ChromeDino chromeDino,
    required _ChromeDinoAnchor anchor,
  }) {
    initialize(
      chromeDino.body,
      anchor.body,
      chromeDino.body.position + anchor.body.position,
    );
    enableLimit = true;
    // TODO(alestiago): Apply design angle value.
    const angle = math.pi / 3.5;
    lowerAngle = -angle / 2;
    upperAngle = angle / 2;

    enableMotor = true;
    // TODO(alestiago): Tune this values.
    maxMotorTorque = motorSpeed = chromeDino.body.mass * 30;
  }
}

class _ChromeDinoJoint extends RevoluteJoint {
  _ChromeDinoJoint(_ChromeDinoAnchorRevoluteJointDef def) : super(def);

  /// Sweeps the [ChromeDino] up and down repeatedly.
  void _swivel() {
    setMotorSpeed(-motorSpeed);
  }
}
