// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

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
      SpaceshipHoleBallContactCallback(),
      SpaceshipEntranceBallContactCallback(),
    ]);

    addAll([
      SpaceshipSaucer()..initialPosition = position,
      SpaceshipEntrance()..initialPosition = position,
      AndroidHead()..initialPosition = position,
      SpaceshipHole(
        onExitLayer: Layer.spaceshipExitRail,
        onExitElevation: 2,
      )..initialPosition = position - Vector2(5.2, 4.8),
      SpaceshipHole()..initialPosition = position - Vector2(-7.2, 0.8),
      SpaceshipWall()..initialPosition = position,
    ]);
  }
}

/// {@template spaceship_saucer}
/// A [BodyComponent] for the base, or the saucer of the spaceship
/// {@endtemplate}
class SpaceshipSaucer extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_saucer}
  // TODO(ruimiguel): apply Elevated when PR merged.
  SpaceshipSaucer() : super(priority: 3) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceshipSaucer.keyName,
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
    final circleShape = CircleShape()..radius = 3;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)..isSensor = true,
      );
  }
}

/// {@template spaceship_bridge}
/// A [BodyComponent] that provides both the collision and the rotation
/// animation for the bridge.
/// {@endtemplate}
class AndroidHead extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_bridge}
  AndroidHead() : super(priority: 4) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final sprite = await gameRef.images.load(
      Assets.images.spaceshipBridge.keyName,
    );

    await add(
      SpriteAnimationComponent.fromFrameData(
        sprite,
        SpriteAnimationData.sequenced(
          amount: 72,
          amountPerRow: 24,
          stepTime: 0.05,
          textureSize: Vector2(82, 100),
        ),
        size: Vector2(8.2, 10),
        position: Vector2(0, -2),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = 2;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)..restitution = 0.4,
      );
  }
}

/// {@template spaceship_entrance}
/// A sensor [BodyComponent] used to detect when the ball enters the
/// the spaceship area in order to modify its filter data so the ball
/// can correctly collide only with the Spaceship
/// {@endtemplate}
class SpaceshipEntrance extends RampOpening {
  /// {@macro spaceship_entrance}
  SpaceshipEntrance()
      : super(
          pathwayLayer: Layer.spaceship,
          orientation: RampOrientation.up,
        ) {
    layer = Layer.spaceship;
  }

  /// Priority order for [SpaceshipHole] on enter.
  // TODO(ruimiguel): apply Elevated when PR merged.
  final int onEnterElevation = 4;

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

/// {@template spaceship_hole}
/// A sensor [BodyComponent] responsible for sending the [Ball]
/// out from the [Spaceship].
/// {@endtemplate}
class SpaceshipHole extends RampOpening {
  /// {@macro spaceship_hole}
  SpaceshipHole({Layer? onExitLayer, this.onExitElevation = 1})
      : super(
          pathwayLayer: Layer.spaceship,
          outsideLayer: onExitLayer,
          orientation: RampOrientation.up,
        ) {
    layer = Layer.spaceship;
  }

  /// Priority order for [SpaceshipHole] on exit.
  // TODO(ruimiguel): apply Elevated when PR merged.
  final int onExitElevation;

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(0, 4.2),
      arcRadius: 6,
      angle: 1,
      rotation: 60 * pi / 180,
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
/// surrounding the spaceship, with a small opening to allow the
/// [Ball] to get inside the spaceship saucer.
/// It also contains the [SpriteComponent] for the lower wall
/// {@endtemplate}
class SpaceshipWall extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_wall}
  // TODO(ruimiguel): apply Elevated when PR merged
  SpaceshipWall() : super(priority: 4) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    renderBody = false;

    final wallShape = _SpaceshipWallShape();

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..angle = 90 * pi / 172
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(wallShape)..restitution = 1,
      );
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and the [SpaceshipEntrance].
///
/// It modifies the [Ball] priority and filter data so it can appear on top of
/// the spaceship and also only collide with the spaceship.
class SpaceshipEntranceBallContactCallback
    extends ContactCallback<SpaceshipEntrance, Ball> {
  @override
  void begin(SpaceshipEntrance entrance, Ball ball, _) {
    ball
      // TODO(ruimiguel): apply Elevated when PR merged.
      ..priority = entrance.onEnterElevation
      ..gameRef.reorderChildren()
      ..layer = Layer.spaceship;
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipHole].
///
/// It sets the [Ball] priority and filter data so it will "be back" on the
/// board.
class SpaceshipHoleBallContactCallback
    extends ContactCallback<SpaceshipHole, Ball> {
  @override
  void begin(SpaceshipHole hole, Ball ball, _) {
    ball
      // TODO(ruimiguel): apply Elevated when PR merged.
      ..priority = hole.onExitElevation
      ..gameRef.reorderChildren()
      ..layer = hole.outsideLayer;
  }
}
