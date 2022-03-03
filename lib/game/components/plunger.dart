import 'package:flame_forge2d/flame_forge2d.dart';

/// {@template plunger}
/// Plunger body component to be pulled and released by the player to launch
/// the pinball.
///
/// The plunger body ignores gravity so the player can control its downward
/// pull.
/// {@endtemplate}
class Plunger extends BodyComponent {
  /// {@macro plunger}
  Plunger(this._position);

  final Vector2 _position;

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(2.5, 1.5);

    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic
      ..gravityScale = 0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Set a contstant downward velocity on the plunger body.
  void pull() {
    body.linearVelocity = Vector2(0, -7);
  }

  /// Set an upward velocity on the plunger body. The velocity's magnitude
  /// depends on how far the plunger has been pulled from its original position.
  void release() {
    final velocity = (_position.y - body.position.y) * 9;
    body.linearVelocity = Vector2(0, velocity);
  }
}

/// {@template plunger_anchor_prismatic_joint_def}
/// Prismatic joint def between a [Plunger] and an anchor body given motion on
/// the vertical axis.
///
/// The [Plunger] is constrained to vertical motion between its starting
/// position and the anchor body. The anchor needs to be below the plunger for
/// this joint to function properly.
/// {@endtemplate}
class PlungerAnchorPrismaticJointDef extends PrismaticJointDef {
  /// {@macro plunger_anchor_prismatic_joint_def}
  PlungerAnchorPrismaticJointDef({
    required Plunger plunger,
    required BodyComponent anchor,
  }) {
    initialize(
      plunger.body,
      anchor.body,
      anchor.body.position,
      Vector2(0, -1),
    );
    enableLimit = true;
    lowerTranslation = double.negativeInfinity;
    collideConnected = true;
  }
}
