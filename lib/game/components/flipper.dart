import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

/// {@template flipper}
/// A bat, typically found in pairs at the bottom of the board.
///
/// [Flipper] can be controlled by the player in an arc motion.
/// {@endtemplate flipper}
class Flipper extends BodyComponent with KeyboardHandler, InitialPosition {
  /// {@macro flipper}
  Flipper._({
    required this.side,
    required List<LogicalKeyboardKey> keys,
  }) : _keys = keys;

  Flipper._left()
      : this._(
          side: BoardSide.left,
          keys: [
            LogicalKeyboardKey.arrowLeft,
            LogicalKeyboardKey.keyA,
          ],
        );

  Flipper._right()
      : this._(
          side: BoardSide.right,
          keys: [
            LogicalKeyboardKey.arrowRight,
            LogicalKeyboardKey.keyD,
          ],
        );

  /// Constructs a [Flipper] from a [BoardSide].
  ///
  /// A [Flipper._right] and [Flipper._left] besides being mirrored
  /// horizontally, also have different [LogicalKeyboardKey]s that control them.
  factory Flipper.fromSide({
    required BoardSide side,
  }) {
    switch (side) {
      case BoardSide.left:
        return Flipper._left();
      case BoardSide.right:
        return Flipper._right();
    }
  }

  /// Asset location of the sprite that renders with the [Flipper].
  ///
  /// Sprite is preloaded by [PinballGameAssetsX].
  static const spritePath = 'components/flipper.png';

  /// The size of the [Flipper].
  static final size = Vector2(12, 2.8);

  /// The speed required to move the [Flipper] to its highest position.
  ///
  /// The higher the value, the faster the [Flipper] will move.
  static const double _speed = 60;

  /// Whether the [Flipper] is on the left or right side of the board.
  ///
  /// A [Flipper] with [BoardSide.left] has a counter-clockwise arc motion,
  /// whereas a [Flipper] with [BoardSide.right] has a clockwise arc motion.
  final BoardSide side;

  /// The [LogicalKeyboardKey]s that will control the [Flipper].
  ///
  /// [onKeyEvent] method listens to when one of these keys is pressed.
  final List<LogicalKeyboardKey> _keys;

  /// Applies downward linear velocity to the [Flipper], moving it to its
  /// resting position.
  void _moveDown() {
    body.linearVelocity = Vector2(0, -_speed);
  }

  /// Applies upward linear velocity to the [Flipper], moving it to its highest
  /// position.
  void _moveUp() {
    body.linearVelocity = Vector2(0, _speed);
  }

  /// Loads the sprite that renders with the [Flipper].
  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(spritePath);
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
    );

    if (side.isRight) {
      spriteComponent.flipHorizontally();
    }

    await add(spriteComponent);
  }

  /// Anchors the [Flipper] to the [RevoluteJoint] that controls its arc motion.
  Future<void> _anchorToJoint() async {
    final anchor = FlipperAnchor(flipper: this);
    await add(anchor);

    final jointDef = FlipperAnchorRevoluteJointDef(
      flipper: this,
      anchor: anchor,
    );
    // TODO(alestiago): Remove casting once the following is closed:
    // https://github.com/flame-engine/forge2d/issues/36
    final joint = world.createJoint(jointDef) as RevoluteJoint;

    // FIXME(erickzanardo): when mounted the initial position is not fully
    // reached.
    unawaited(
      mounted.whenComplete(
        () => FlipperAnchorRevoluteJointDef.unlock(joint, side),
      ),
    );
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];
    final isLeft = side.isLeft;

    final bigCircleShape = CircleShape()..radius = 1.75;
    bigCircleShape.position.setValues(
      isLeft
          ? -(size.x / 2) + bigCircleShape.radius
          : (size.x / 2) - bigCircleShape.radius,
      0,
    );
    final bigCircleFixtureDef = FixtureDef(bigCircleShape);
    fixturesDef.add(bigCircleFixtureDef);

    final smallCircleShape = CircleShape()..radius = 0.9;
    smallCircleShape.position.setValues(
      isLeft
          ? (size.x / 2) - smallCircleShape.radius
          : -(size.x / 2) + smallCircleShape.radius,
      0,
    );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);
    fixturesDef.add(smallCircleFixtureDef);

    final trapeziumVertices = isLeft
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
    paint = Paint()..color = Colors.transparent;
    await Future.wait([
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

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      _moveUp();
    } else if (event is RawKeyUpEvent) {
      _moveDown();
    }

    return false;
  }
}

/// {@template flipper_anchor}
/// [JointAnchor] positioned at the end of a [Flipper].
///
/// The end of a [Flipper] depends on its [Flipper.side].
/// {@endtemplate}
class FlipperAnchor extends JointAnchor {
  /// {@macro flipper_anchor}
  FlipperAnchor({
    required Flipper flipper,
  }) {
    initialPosition = Vector2(
      flipper.side.isLeft
          ? flipper.body.position.x - Flipper.size.x / 2
          : flipper.body.position.x + Flipper.size.x / 2,
      flipper.body.position.y,
    );
  }
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to a [FlipperAnchor] to achieve an arc motion.
/// {@endtemplate}
class FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required FlipperAnchor anchor,
  }) {
    initialize(
      flipper.body,
      anchor.body,
      anchor.body.position,
    );
    enableLimit = true;

    final angle = (flipper.side.isLeft ? _sweepingAngle : -_sweepingAngle) / 2;
    lowerAngle = upperAngle = angle;
  }

  /// The total angle of the arc motion.
  static const _sweepingAngle = math.pi / 3.5;

  /// Unlocks the [Flipper] from its resting position.
  ///
  /// The [Flipper] is locked when initialized in order to force it to be at
  /// its resting position.
  // TODO(alestiago): consider refactor once the issue is solved:
  // https://github.com/flame-engine/forge2d/issues/36
  static void unlock(RevoluteJoint joint, BoardSide side) {
    late final double upperLimit, lowerLimit;
    switch (side) {
      case BoardSide.left:
        lowerLimit = -joint.lowerLimit;
        upperLimit = joint.upperLimit;
        break;
      case BoardSide.right:
        lowerLimit = joint.lowerLimit;
        upperLimit = -joint.upperLimit;
    }

    joint.setLimits(lowerLimit, upperLimit);
  }
}
