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

  /// The size of the dinosour mouth.
  static final size = Vector2(5, 2.5);

  /// Anchors the [ChromeDino] to the [RevoluteJoint] that controls its arc
  /// motion.
  Future<void> _anchorToJoint() async {
    final anchor = _ChromeDinoAnchor(chromeDino: this);
    await add(anchor);

    final jointDef = _ChromeDinoAnchorRevoluteJointDef(
      chromeDino: this,
      anchor: anchor,
    );
    final joint = _ChromeDinoJoint(jointDef)..create(world);
    joint.swivel(joint, removed);
  }

  // TODO(alestiago): Remove once the following is added to Flame.
  // ignore: public_member_api_docs
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

  List<FixtureDef> _createFixtureDefs() {
    final fixtureDefs = <FixtureDef>[];

    // TODO(alestiago): Subject to change when sprites are added.
    final box = PolygonShape()..setAsBoxXY(size.x / 2, size.y / 2);
    final fixtureDef = FixtureDef(box)
      ..shape = box
      ..density = 1
      ..friction = 0.3
      ..restitution = 0.1
      ..isSensor = true;
    fixtureDefs.add(fixtureDef);

    final upperEdge = EdgeShape()
      ..set(
        Vector2(-size.x / 2, -size.y / 2),
        Vector2(size.x / 2, -size.y / 2),
      );
    final upperEdgeDef = FixtureDef(upperEdge)..density = 0.5;
    fixtureDefs.add(upperEdgeDef);

    final lowerEdge = EdgeShape()
      ..set(
        Vector2(-size.x / 2, size.y / 2),
        Vector2(size.x / 2, size.y / 2),
      );
    final lowerEdgeDef = FixtureDef(lowerEdge)..density = 0.5;
    fixtureDefs.add(lowerEdgeDef);

    final rightEdge = EdgeShape()
      ..set(
        Vector2(size.x / 2, -size.y / 2),
        Vector2(size.x / 2, size.y / 2),
      );
    final rightEdgeDef = FixtureDef(rightEdge)..density = 0.5;
    fixtureDefs.add(rightEdgeDef);

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
  _ChromeDinoAnchor({
    required ChromeDino chromeDino,
  }) {
    initialPosition = Vector2(
      chromeDino.body.position.x + ChromeDino.size.x / 2,
      chromeDino.body.position.y,
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
      anchor.body.position,
    );
    enableLimit = true;
    const angle = math.pi / 3.5;
    lowerAngle = -angle / 2;
    upperAngle = angle / 2;

    enableMotor = true;
    // TODO(alestiago): Tune this values.
    maxMotorTorque = 999;
    motorSpeed = 999;
  }
}

class _ChromeDinoJoint extends RevoluteJoint {
  _ChromeDinoJoint(_ChromeDinoAnchorRevoluteJointDef def) : super(def);

  // TODO(alestiago): Remove once Forge2D supports custom joints.
  void create(World world) {
    world.joints.add(this);
    bodyA.joints.add(this);
    bodyB.joints.add(this);
  }

  /// Sweeps the [ChromeDino] up and down repeatedly.
  void swivel(RevoluteJoint joint, Completer completer) {
    Future.doWhile(() async {
      if (completer.isCompleted) return false;

      // TODO(alestiago): Tune this values.
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      joint.setMotorSpeed(-joint.motorSpeed);
      return true;
    });
  }
}
