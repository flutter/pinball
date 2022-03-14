import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// playfield.
///
/// [Plunger] ignores gravity so the player controls its downward [_pull].
/// {@endtemplate}
class Plunger extends BodyComponent with KeyboardHandler {
  /// {@macro plunger}
  Plunger({
    required Vector2 position,
    required this.compressionDistance,
  }) : _position = position;

  /// The initial position of the [Plunger] body.
  final Vector2 _position;

  /// Distance the plunger can lower.
  final double compressionDistance;

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(2, 0.75);

    final fixtureDef = FixtureDef(shape)..density = 5;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic
      ..gravityScale = 0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Set a constant downward velocity on the [Plunger].
  void _pull() {
    body.linearVelocity = Vector2(0, -3);
  }

  /// Set an upward velocity on the [Plunger].
  ///
  /// The velocity's magnitude depends on how far the [Plunger] has been pulled
  /// from its original [_position].
  void _release() {
    final velocity = (_position.y - body.position.y) * 9;
    body.linearVelocity = Vector2(0, velocity);
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final keys = [
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.keyS,
    ];
    // TODO(alestiago): Check why false cancels the event for other components.
    // Investigate why return is of type [bool] expected instead of a type
    // [KeyEventResult].
    if (!keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      _pull();
    } else if (event is RawKeyUpEvent) {
      _release();
    }

    return true;
  }
}

/// {@template plunger_anchor}
/// [JointAnchor] positioned below a [Plunger].
/// {@endtemplate}
class PlungerAnchor extends JointAnchor {
  /// {@macro plunger_anchor}
  PlungerAnchor({
    required Plunger plunger,
  }) : super(
          position: Vector2(
            plunger.body.position.x,
            plunger.body.position.y - plunger.compressionDistance,
          ),
        );
}

/// {@template plunger_anchor_prismatic_joint_def}
/// [PrismaticJointDef] between a [Plunger] and an [JointAnchor] with motion on
/// the vertical axis.
///
/// The [Plunger] is constrained vertically between its starting position and
/// the [JointAnchor]. The [JointAnchor] must be below the [Plunger].
/// {@endtemplate}
class PlungerAnchorPrismaticJointDef extends PrismaticJointDef {
  /// {@macro plunger_anchor_prismatic_joint_def}
  PlungerAnchorPrismaticJointDef({
    required Plunger plunger,
    required PlungerAnchor anchor,
  }) {
    initialize(
      plunger.body,
      anchor.body,
      anchor.body.position,
      Vector2(0, -1),
    );
    enableLimit = true;
    lowerTranslation = double.negativeInfinity;
    enableMotor = true;
    motorSpeed = 50;
    maxMotorForce = motorSpeed;
    collideConnected = true;
  }
}
