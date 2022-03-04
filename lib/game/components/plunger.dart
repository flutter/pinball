import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// playfield.
///
/// [Plunger] ignores gravity so the player controls its downward [pull].
/// {@endtemplate}
class Plunger extends BodyComponent {
  /// {@macro plunger}
  Plunger({required Vector2 position}) : _position = position;

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

  /// Set a constant downward velocity on the [Plunger].
  void pull() {
    body.linearVelocity = Vector2(0, -7);
  }

  /// Set an upward velocity on the [Plunger].
  ///
  /// The velocity's magnitude depends on how far the [Plunger] has been pulled
  /// from its original [_position].
  void release() {
    final velocity = (_position.y - body.position.y) * 9;
    body.linearVelocity = Vector2(0, velocity);
  }
}

/// {@template plunger_anchor_prismatic_joint_def}
/// [PrismaticJointDef] between a [Plunger] and an [Anchor] with motion on
/// the vertical axis.
///
/// The [Plunger] is constrained to vertically between its starting position and
/// the [Anchor]. The [Anchor] must be below the [Plunger].
/// {@endtemplate}
class PlungerAnchorPrismaticJointDef extends PrismaticJointDef {
  /// {@macro plunger_anchor_prismatic_joint_def}
  PlungerAnchorPrismaticJointDef({
    required Plunger plunger,
    required Anchor anchor,
  }) : assert(
          anchor.body.position.y < plunger.body.position.y,
          "Anchor can't be positioned above the Plunger",
        ) {
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
