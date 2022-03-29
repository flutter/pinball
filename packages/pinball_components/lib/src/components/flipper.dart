import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flipper}
/// A bat, typically found in pairs at the bottom of the board.
///
/// [Flipper] can be controlled by the player in an arc motion.
/// {@endtemplate flipper}
class Flipper extends BodyComponent with KeyboardHandler, InitialPosition {
  /// {@macro flipper}
  Flipper({
    required this.side,
  });

  /// The size of the [Flipper].
  static final size = Vector2(13.5, 4.3);

  /// The speed required to move the [Flipper] to its highest position.
  ///
  /// The higher the value, the faster the [Flipper] will move.
  static const double _speed = 60;

  /// Whether the [Flipper] is on the left or right side of the board.
  ///
  /// A [Flipper] with [BoardSide.left] has a counter-clockwise arc motion,
  /// whereas a [Flipper] with [BoardSide.right] has a clockwise arc motion.
  final BoardSide side;

  /// Applies downward linear velocity to the [Flipper], moving it to its
  /// resting position.
  void moveDown() {
    body.linearVelocity = Vector2(0, -_speed);
  }

  /// Applies upward linear velocity to the [Flipper], moving it to its highest
  /// position.
  void moveUp() {
    body.linearVelocity = Vector2(0, _speed);
  }

  /// Loads the sprite that renders with the [Flipper].
  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      (side.isLeft)
          ? Assets.images.flipper.left.keyName
          : Assets.images.flipper.right.keyName,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
    );

    await add(spriteComponent);
  }

  /// Anchors the [Flipper] to the [RevoluteJoint] that controls its arc motion.
  Future<void> _anchorToJoint() async {
    final anchor = _FlipperAnchor(flipper: this);
    await add(anchor);

    final jointDef = _FlipperAnchorRevoluteJointDef(
      flipper: this,
      anchor: anchor,
    );
    final joint = _FlipperJoint(jointDef);
    world.createJoint2(joint);
    unawaited(mounted.whenComplete(joint.unlock));
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];
    final direction = side.direction;

    final assetShadow = Flipper.size.x * 0.012 * -direction;
    final size = Vector2(
      Flipper.size.x - (assetShadow * 2),
      Flipper.size.y,
    );

    final bigCircleShape = CircleShape()..radius = size.y / 2 - 0.2;
    bigCircleShape.position.setValues(
      ((size.x / 2) * direction) +
          (bigCircleShape.radius * -direction) +
          assetShadow,
      0,
    );
    final bigCircleFixtureDef = FixtureDef(bigCircleShape);
    fixturesDef.add(bigCircleFixtureDef);

    final smallCircleShape = CircleShape()..radius = size.y * 0.23;
    smallCircleShape.position.setValues(
      ((size.x / 2) * -direction) +
          (smallCircleShape.radius * direction) -
          assetShadow,
      0,
    );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);
    fixturesDef.add(smallCircleFixtureDef);

    final trapeziumVertices = side.isLeft
        ? [
            Vector2(bigCircleShape.position.x, bigCircleShape.radius),
            Vector2(smallCircleShape.position.x, smallCircleShape.radius),
            Vector2(smallCircleShape.position.x, -smallCircleShape.radius),
            Vector2(bigCircleShape.position.x, -bigCircleShape.radius),
          ]
        : [
            Vector2(smallCircleShape.position.x, smallCircleShape.radius),
            Vector2(bigCircleShape.position.x, bigCircleShape.radius),
            Vector2(bigCircleShape.position.x, -bigCircleShape.radius),
            Vector2(smallCircleShape.position.x, -smallCircleShape.radius),
          ];
    final trapezium = PolygonShape()..set(trapeziumVertices);
    final trapeziumFixtureDef = FixtureDef(trapezium)
      ..density = 50.0 // TODO(alestiago): Use a proper density.
      ..friction = .1; // TODO(alestiago): Use a proper friction.
    fixturesDef.add(trapeziumFixtureDef);

    return fixturesDef;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    await Future.wait<void>([
      _loadSprite(),
      _anchorToJoint(),
    ]);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = initialPosition
      ..gravityScale = 0
      ..type = BodyType.dynamic;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

/// {@template flipper_anchor}
/// [JointAnchor] positioned at the end of a [Flipper].
///
/// The end of a [Flipper] depends on its [Flipper.side].
/// {@endtemplate}
class _FlipperAnchor extends JointAnchor {
  /// {@macro flipper_anchor}
  _FlipperAnchor({
    required Flipper flipper,
  }) {
    initialPosition = Vector2(
      flipper.body.position.x + ((Flipper.size.x * flipper.side.direction) / 2),
      flipper.body.position.y,
    );
  }
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to a [_FlipperAnchor] to achieve an arc motion.
/// {@endtemplate}
class _FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  _FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required _FlipperAnchor anchor,
  }) : side = flipper.side {
    enableLimit = true;
    initialize(
      flipper.body,
      anchor.body,
      anchor.body.position,
    );
  }

  final BoardSide side;
}

/// {@template flipper_joint}
/// [RevoluteJoint] that controls the arc motion of a [Flipper].
/// {@endtemplate}
class _FlipperJoint extends RevoluteJoint {
  /// {@macro flipper_joint}
  _FlipperJoint(_FlipperAnchorRevoluteJointDef def)
      : side = def.side,
        super(def) {
    lock();
  }

  /// The total angle of the arc motion.
  static const _sweepingAngle = math.pi / 3.5;

  final BoardSide side;

  /// Locks the [Flipper] to its resting position.
  ///
  /// The joint is locked when initialized in order to force the [Flipper]
  /// at its resting position.
  void lock() {
    const angle = _sweepingAngle / 2;
    setLimits(
      -angle * side.direction,
      -angle * side.direction,
    );
  }

  /// Unlocks the [Flipper] from its resting position.
  void unlock() {
    const angle = _sweepingAngle / 2;
    setLimits(-angle, angle);
  }
}

// TODO(alestiago): Remove once Forge2D supports custom joints.
extension on World {
  void createJoint2(Joint joint) {
    assert(!isLocked, '');

    joints.add(joint);

    joint.bodyA.joints.add(joint);
    joint.bodyB.joints.add(joint);
  }
}
