import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// playfield.
///
/// [Plunger] ignores gravity so the player controls its downward [_pull].
/// {@endtemplate}
class Plunger extends BodyComponent with KeyboardHandler, InitialPosition {
  /// {@macro plunger}
  Plunger({
    required this.compressionDistance,
    // TODO(ruimiguel): set to priority +1 over LaunchRamp once all priorities
    // are fixed.
  }) : super(priority: 0);

  /// Distance the plunger can lower.
  final double compressionDistance;

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        1.35,
        0.5,
        Vector2.zero(),
        BoardDimensions.perspectiveAngle,
      );

    final fixtureDef = FixtureDef(shape)..density = 80;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.dynamic
      ..gravityScale = 0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Set a constant downward velocity on the [Plunger].
  void _pull() {
    body.linearVelocity = Vector2(0, -7);
  }

  /// Set an upward velocity on the [Plunger].
  ///
  /// The velocity's magnitude depends on how far the [Plunger] has been pulled
  /// from its original [initialPosition].
  void _release() {
    final velocity = (initialPosition.y - body.position.y) * 5;
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
    if (!keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      _pull();
    } else if (event is RawKeyUpEvent) {
      _release();
    }

    return false;
  }

  /// Anchors the [Plunger] to the [PrismaticJoint] that controls its vertical
  /// motion.
  Future<void> _anchorToJoint() async {
    final anchor = PlungerAnchor(plunger: this);
    await add(anchor);

    final jointDef = PlungerAnchorPrismaticJointDef(
      plunger: this,
      anchor: anchor,
    );

    world.createJoint(
      PrismaticJoint(jointDef)..setLimits(-compressionDistance, 0),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _anchorToJoint();

    renderBody = false;

    await _loadSprite();
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.components.plunger.path,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(5.5, 40),
        anchor: Anchor.center,
        position: Vector2(2, 19),
        angle: -0.033,
      ),
    );
  }
}

/// {@template plunger_anchor}
/// [JointAnchor] positioned below a [Plunger].
/// {@endtemplate}
class PlungerAnchor extends JointAnchor {
  /// {@macro plunger_anchor}
  PlungerAnchor({
    required Plunger plunger,
  }) {
    initialPosition = Vector2(
      0,
      -plunger.compressionDistance,
    );
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = initialPosition
      ..type = BodyType.static;
    return world.createBody(bodyDef);
  }
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
      plunger.body.position + anchor.body.position,
      Vector2(18.6, BoardDimensions.bounds.height),
    );
    enableLimit = true;
    lowerTranslation = double.negativeInfinity;
    enableMotor = true;
    motorSpeed = 1000;
    maxMotorForce = motorSpeed;
    collideConnected = true;
  }
}
