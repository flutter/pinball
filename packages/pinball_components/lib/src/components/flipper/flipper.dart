import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:pinball_components/pinball_components.dart';

export 'behaviors/behaviors.dart';

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
          children: [
            _FlipperSpriteComponent(side: side),
            FlipperJointingBehavior(),
            FlipperKeyControllingBehavior(),
          ],
        );

  /// Creates a [Flipper] without any children.
  ///
  /// This can be used for testing [Flipper]'s behaviors in isolation.
  @visibleForTesting
  Flipper.test({required this.side});

  /// The size of the [Flipper].
  static final size = Vector2(13.5, 4.3);

  /// The speed required to move the [Flipper] to its highest position.
  ///
  /// The higher the value, the faster the [Flipper] will move.
  static const double _speed = 90;

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

    final smallCircleShape = CircleShape()..radius = size.y * 0.23;
    smallCircleShape.position.setValues(
      ((size.x / 2) * -direction) +
          (smallCircleShape.radius * direction) -
          assetShadow,
      0,
    );

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

    return [
      FixtureDef(bigCircleShape),
      FixtureDef(smallCircleShape),
      FixtureDef(
        trapezium,
        density: 50, // TODO(alestiago): Use a proper density.
        friction: .1, // TODO(alestiago): Use a proper friction.
      ),
    ];
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
