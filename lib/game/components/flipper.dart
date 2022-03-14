import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart' show PositionComponent, SpriteComponent;
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';

/// {@template flipper_group}
/// Loads a [Flipper.right] and a [Flipper.left].
/// {@endtemplate}
class FlipperGroup extends PositionComponent {
  /// {@macro flipper_group}
  FlipperGroup({
    required Vector2 position,
    required this.spacing,
  }) : super(position: position);

  /// The amount of space between the [Flipper.right] and [Flipper.left].
  final double spacing;

  @override
  Future<void> onLoad() async {
    final leftFlipper = Flipper.left(
      position: Vector2(
        position.x - (Flipper.width / 2) - (spacing / 2),
        position.y,
      ),
    );
    await add(leftFlipper);

    final rightFlipper = Flipper.right(
      position: Vector2(
        position.x + (Flipper.width / 2) + (spacing / 2),
        position.y,
      ),
    );
    await add(rightFlipper);
  }
}

/// {@template flipper}
/// A bat, typically found in pairs at the bottom of the board.
///
/// [Flipper] can be controlled by the player in an arc motion.
/// {@endtemplate flipper}
class Flipper extends PositionBodyComponent with KeyboardHandler {
  /// {@macro flipper}
  Flipper._({
    required Vector2 position,
    required this.side,
    required List<LogicalKeyboardKey> keys,
  })  : _position = position,
        _keys = keys,
        super(size: Vector2(width, height));

  /// A left positioned [Flipper].
  Flipper.left({
    required Vector2 position,
  }) : this._(
          position: position,
          side: BoardSide.left,
          keys: [
            LogicalKeyboardKey.arrowLeft,
            LogicalKeyboardKey.keyA,
          ],
        );

  /// A right positioned [Flipper].
  Flipper.right({
    required Vector2 position,
  }) : this._(
          position: position,
          side: BoardSide.right,
          keys: [
            LogicalKeyboardKey.arrowRight,
            LogicalKeyboardKey.keyD,
          ],
        );

  /// Asset location of the sprite that renders with the [Flipper].
  ///
  /// Sprite is preloaded by [PinballGameAssetsX].
  static const spritePath = 'components/flipper.png';

  /// The width of the [Flipper].
  static const width = 12.0;

  /// The height of the [Flipper].
  static const height = 2.8;

  /// The speed required to move the [Flipper] to its highest position.
  ///
  /// The higher the value, the faster the [Flipper] will move.
  static const double _speed = 60;

  /// Whether the [Flipper] is on the left or right side of the board.
  ///
  /// A [Flipper] with [BoardSide.left] has a counter-clockwise arc motion,
  /// whereas a [Flipper] with [BoardSide.right] has a clockwise arc motion.
  final BoardSide side;

  /// The initial position of the [Flipper] body.
  final Vector2 _position;

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
    positionComponent = SpriteComponent(
      sprite: sprite,
      size: size,
    );

    if (side.isRight) {
      positionComponent!.flipHorizontally();
    }
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
    final fixtures = <FixtureDef>[];
    final isLeft = side.isLeft;

    final bigCircleShape = CircleShape()..radius = size.y / 2;
    bigCircleShape.position.setValues(
      isLeft
          ? -(size.x / 2) + bigCircleShape.radius
          : (size.x / 2) - bigCircleShape.radius,
      0,
    );
    final bigCircleFixtureDef = FixtureDef(bigCircleShape);
    fixtures.add(bigCircleFixtureDef);

    final smallCircleShape = CircleShape()..radius = bigCircleShape.radius / 2;
    smallCircleShape.position.setValues(
      isLeft
          ? (size.x / 2) - smallCircleShape.radius
          : -(size.x / 2) + smallCircleShape.radius,
      0,
    );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);
    fixtures.add(smallCircleFixtureDef);

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
    fixtures.add(trapeziumFixtureDef);

    return fixtures;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Future.wait([
      _loadSprite(),
      _anchorToJoint(),
    ]);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..gravityScale = 0
      ..type = BodyType.dynamic
      ..position = _position;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // TODO(alestiago): Check why false cancels the event for other components.
    // Investigate why return is of type [bool] expected instead of a type
    // [KeyEventResult].
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      _moveUp();
    } else if (event is RawKeyUpEvent) {
      _moveDown();
    }

    return true;
  }
}

/// {@template flipper_anchor}
/// [Anchor] positioned at the end of a [Flipper].
///
/// The end of a [Flipper] depends on its [Flipper.side].
/// {@endtemplate}
class FlipperAnchor extends Anchor {
  /// {@macro flipper_anchor}
  FlipperAnchor({
    required Flipper flipper,
  }) : super(
          position: Vector2(
            flipper.side.isLeft
                ? flipper.body.position.x - flipper.size.x / 2
                : flipper.body.position.x + flipper.size.x / 2,
            flipper.body.position.y,
          ),
        );
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to a [Anchor] to achieve an arc motion.
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
