import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:pinball_components/pinball_components.dart';

export 'behaviors/behaviors.dart';
export 'cubit/flipper_cubit.dart';

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
            FlameBlocProvider<FlipperCubit, FlipperState>(
              create: FlipperCubit.new,
              children: [FlipperMovingBehavior(strength: 90)],
            ),
          ],
        );

  /// Creates a [Flipper] without any children.
  ///
  /// This can be used for testing [Flipper]'s behaviors in isolation.
  @visibleForTesting
  Flipper.test({required this.side});

  /// The size of the [Flipper].
  static final size = Vector2(13.5, 4.3);

  /// Whether the [Flipper] is on the left or right side of the board.
  ///
  /// A [Flipper] with [BoardSide.left] has a counter-clockwise arc motion,
  /// whereas a [Flipper] with [BoardSide.right] has a clockwise arc motion.
  final BoardSide side;

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
        density: 50,
        friction: .1,
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
