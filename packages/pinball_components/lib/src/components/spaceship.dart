import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template spaceship}
/// A [Blueprint] which creates the spaceship feature.
/// {@endtemplate}
class Spaceship extends Blueprint {
  /// {@macro spaceship}
  Spaceship({required Vector2 position})
      : super(
          components: [
            SpaceshipSaucer()..initialPosition = position,
            _SpaceshipEntrance()..initialPosition = position,
            AndroidHead()..initialPosition = position,
            _SpaceshipHole(
              outsideLayer: Layer.spaceshipExitRail,
              outsidePriority: RenderPriority.ballOnSpaceshipRail,
            )..initialPosition = position - Vector2(5.2, -4.8),
            _SpaceshipHole(
              outsideLayer: Layer.board,
              outsidePriority: RenderPriority.ballOnBoard,
            )..initialPosition = position - Vector2(-7.2, -0.8),
            SpaceshipWall()..initialPosition = position,
          ],
        );

  /// Total size of the spaceship.
  static final size = Vector2(25, 19);
}

/// {@template spaceship_saucer}
/// A [BodyComponent] for the base, or the saucer of the spaceship
/// {@endtemplate}
class SpaceshipSaucer extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_saucer}
  SpaceshipSaucer()
      : super(
          priority: RenderPriority.spaceshipSaucer,
          renderBody: false,
          children: [
            _SpaceshipSaucerSpriteComponent(),
          ],
        ) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 3;
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _SpaceshipSaucerSpriteComponent extends SpriteComponent with HasGameRef {
  _SpaceshipSaucerSpriteComponent()
      : super(
          anchor: Anchor.center,
          // TODO(alestiago): Refactor to use sprite orignial size instead.
          size: Spaceship.size,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Use cached sprite.
    sprite = await gameRef.loadSprite(
      Assets.images.spaceship.saucer.keyName,
    );
  }
}

/// {@template spaceship_bridge}
/// A [BodyComponent] that provides both the collision and the rotation
/// animation for the bridge.
/// {@endtemplate}
class AndroidHead extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_bridge}
  AndroidHead()
      : super(
          priority: RenderPriority.androidHead,
          children: [_AndroidHeadSpriteAnimation()],
          renderBody: false,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = 2;

    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)..restitution = 0.4,
      );
  }
}

class _AndroidHeadSpriteAnimation extends SpriteAnimationComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await gameRef.images.load(
      Assets.images.spaceship.bridge.keyName,
    );
    size = Vector2(8.2, 10);
    position = Vector2(0, -2);
    anchor = Anchor.center;

    final data = SpriteAnimationData.sequenced(
      amount: 72,
      amountPerRow: 24,
      stepTime: 0.05,
      textureSize: size * 10,
    );
    animation = SpriteAnimation.fromFrameData(image, data);
  }
}

class _SpaceshipEntrance extends LayerSensor {
  _SpaceshipEntrance()
      : super(
          insideLayer: Layer.spaceship,
          orientation: LayerEntranceOrientation.up,
          insidePriority: RenderPriority.ballOnSpaceship,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Shape get shape {
    final radius = Spaceship.size.y / 2;
    return PolygonShape()
      ..setAsEdge(
        Vector2(
          radius * cos(20 * pi / 180),
          radius * sin(20 * pi / 180),
        )..rotate(90 * pi / 180),
        Vector2(
          radius * cos(340 * pi / 180),
          radius * sin(340 * pi / 180),
        )..rotate(90 * pi / 180),
      );
  }
}

class _SpaceshipHole extends LayerSensor {
  _SpaceshipHole({required Layer outsideLayer, required int outsidePriority})
      : super(
          insideLayer: Layer.spaceship,
          outsideLayer: outsideLayer,
          orientation: LayerEntranceOrientation.down,
          insidePriority: RenderPriority.ballOnSpaceship,
          outsidePriority: outsidePriority,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(0, -3.2),
      arcRadius: 5,
      angle: 1,
      rotation: -2,
    );
  }
}

/// {@template spaceship_wall_shape}
/// The [ChainShape] that defines the shape of the [SpaceshipWall].
/// {@endtemplate}
class _SpaceshipWallShape extends ChainShape {
  /// {@macro spaceship_wall_shape}
  _SpaceshipWallShape() {
    final minorRadius = (Spaceship.size.y - 2) / 2;
    final majorRadius = (Spaceship.size.x - 2) / 2;

    createChain(
      [
        // TODO(alestiago): Try converting this logic to radian.
        for (var angle = 20; angle <= 340; angle++)
          Vector2(
            minorRadius * cos(angle * pi / 180),
            majorRadius * sin(angle * pi / 180),
          ),
      ],
    );
  }
}

/// {@template spaceship_wall}
/// A [BodyComponent] that provides the collision for the wall
/// surrounding the spaceship.
///
/// It has a small opening to allow the [Ball] to get inside the spaceship
/// saucer.
///
/// It also contains the [SpriteComponent] for the lower wall
/// {@endtemplate}
class SpaceshipWall extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_wall}
  SpaceshipWall()
      : super(
          priority: RenderPriority.spaceshipSaucerWall,
          renderBody: false,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    final shape = _SpaceshipWallShape();
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
      angle: -1.7,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
