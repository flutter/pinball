// ignore_for_file: avoid_renaming_method_parameters

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
class Spaceship extends Forge2DBlueprint {
  /// {@macro spaceship}
  Spaceship({required this.position});

  /// Total size of the spaceship.
  static final size = Vector2(25, 19);

  /// The [position] where the elements will be created
  final Vector2 position;

  @override
  void build(_) {
    addAllContactCallback([
      LayerSensorBallContactCallback<_SpaceshipEntrance>(),
      LayerSensorBallContactCallback<_SpaceshipHole>(),
    ]);

    addAll([
      SpaceshipSaucer()..initialPosition = position,
      _SpaceshipEntrance()..initialPosition = position,
      AndroidHead()..initialPosition = position,
      _SpaceshipHole(
        outsideLayer: Layer.spaceshipExitRail,
        outsidePriority: Ball.spaceshipRailPriority,
      )..initialPosition = position - Vector2(5.2, -4.8),
      _SpaceshipHole()..initialPosition = position - Vector2(-7.2, -0.8),
      SpaceshipWall()..initialPosition = position,
    ]);
  }
}

/// {@template spaceship_saucer}
/// A [BodyComponent] for the base, or the saucer of the spaceship
/// {@endtemplate}
class SpaceshipSaucer extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_saucer}
  SpaceshipSaucer() : super(priority: Ball.spaceshipPriority - 1) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.saucer.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Spaceship.size,
        anchor: Anchor.center,
      ),
    );

    renderBody = false;
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

/// {@template spaceship_bridge}
/// A [BodyComponent] that provides both the collision and the rotation
/// animation for the bridge.
/// {@endtemplate}
class AndroidHead extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_bridge}
  AndroidHead()
      : super(
          priority: Ball.spaceshipPriority + 1,
          children: [_AndroidHeadSpriteAnimation()],
        ) {
    renderBody = false;
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
          insidePriority: Ball.spaceshipPriority,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Shape get shape {
    renderBody = false;
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
  _SpaceshipHole({Layer? outsideLayer, int? outsidePriority = 1})
      : super(
          insideLayer: Layer.spaceship,
          outsideLayer: outsideLayer,
          orientation: LayerEntranceOrientation.down,
          insidePriority: 4,
          outsidePriority: outsidePriority,
        ) {
    renderBody = false;
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
  SpaceshipWall() : super(priority: Ball.spaceshipPriority + 1) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    renderBody = false;

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
