import 'dart:async';

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
  }) : super(
          renderBody: false,
          children: [_FlipperSpriteComponent(side: side)],
        );

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
    body.linearVelocity = Vector2(0, _speed);
  }

  /// Applies upward linear velocity to the [Flipper], moving it to its highest
  /// position.
  void moveUp() {
    body.linearVelocity = Vector2(0, -_speed);
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
    world.createJoint(joint);
  }

  List<FixtureDef> _createFixtureDefs() {
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

    final smallCircleShape = CircleShape()..radius = size.y * 0.23;
    smallCircleShape.position.setValues(
      ((size.x / 2) * -direction) +
          (smallCircleShape.radius * direction) -
          assetShadow,
      0,
    );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);

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
    final trapeziumFixtureDef = FixtureDef(
      trapezium,
      density: 50, // TODO(alestiago): Use a proper density.
      friction: .1, // TODO(alestiago): Use a proper friction.
    );

    return [
      bigCircleFixtureDef,
      smallCircleFixtureDef,
      trapeziumFixtureDef,
    ];
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _anchorToJoint();
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      gravityScale: Vector2.zero(),
      type: BodyType.dynamic,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  void onMount() {
    super.onMount();

    gameRef.ready().whenComplete(
          () => body.joints.whereType<_FlipperJoint>().first.unlock(),
        );
  }
}

class _FlipperSpriteComponent extends SpriteComponent with HasGameRef {
  _FlipperSpriteComponent({required BoardSide side})
      : _side = side,
        super(anchor: Anchor.center);

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        (_side.isLeft)
            ? Assets.images.flipper.left.keyName
            : Assets.images.flipper.right.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
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
      (Flipper.size.x * flipper.side.direction) / 2 -
          (1.65 * flipper.side.direction),
      -0.15,
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
      flipper.body.position + anchor.body.position,
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

  /// Half the angle of the arc motion.
  static const _halfSweepingAngle = 0.611;

  final BoardSide side;

  /// Locks the [Flipper] to its resting position.
  ///
  /// The joint is locked when initialized in order to force the [Flipper]
  /// at its resting position.
  void lock() {
    final angle = _halfSweepingAngle * side.direction;
    setLimits(angle, angle);
  }

  /// Unlocks the [Flipper] from its resting position.
  void unlock() {
    const angle = _halfSweepingAngle;
    setLimits(-angle, angle);
  }
}
