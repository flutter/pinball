// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';

/// A [Blueprint] which creates the spaceship feature.
class Spaceship extends Forge2DBlueprint {
  /// Total size of the spaceship
  static const radius = 10.0;

  @override
  void build() {
    final position = Vector2(
      PinballGame.boardBounds.left + radius + 0.5,
      PinballGame.boardBounds.center.dy + 34,
    );

    addAllContactCallback([
      SpaceshipHoleBallContactCallback(),
      SpaceshipEntranceBallContactCallback(),
    ]);

    addAll([
      SpaceshipSaucer()..initialPosition = position,
      SpaceshipEntrance()..initialPosition = position,
      SpaceshipBridge()..initialPosition = position,
      SpaceshipBridgeTop()..initialPosition = position + Vector2(0, 5.5),
      SpaceshipHole()..initialPosition = position - Vector2(5, 4),
      SpaceshipHole()..initialPosition = position - Vector2(-5, 4),
      SpaceshipWall()..initialPosition = position,
    ]);
  }
}

/// {@template spaceship_saucer}
/// A [BodyComponent] for the base, or the saucer of the spaceship
/// {@endtemplate}
class SpaceshipSaucer extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_saucer}
  SpaceshipSaucer() : super(priority: 2) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = await Future.wait([
      gameRef.loadSprite(Assets.images.components.spaceship.saucer.path),
      gameRef.loadSprite(Assets.images.components.spaceship.upper.path),
    ]);

    await add(
      SpriteComponent(
        sprite: sprites.first,
        size: Vector2.all(Spaceship.radius * 2),
        anchor: Anchor.center,
      ),
    );

    await add(
      SpriteComponent(
        sprite: sprites.last,
        size: Vector2((Spaceship.radius * 2) + 0.5, Spaceship.radius),
        anchor: Anchor.center,
        position: Vector2(0, -((Spaceship.radius * 2) / 3.5)),
      ),
    );

    renderBody = false;
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = Spaceship.radius;

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

/// {@spaceship_bridge_top}
/// The bridge of the spaceship (the android head) is divided in two
// [BodyComponent]s, this is the top part of it which contains a single sprite
/// {@endtemplate}
class SpaceshipBridgeTop extends BodyComponent with InitialPosition {
  /// {@macro spaceship_bridge_top}
  SpaceshipBridgeTop() : super(priority: 6);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.components.spaceship.androidTop.path,
    );
    await add(
      SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        size: Vector2((Spaceship.radius * 2) / 2.5 - 1, Spaceship.radius / 2.5),
      ),
    );
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef);
  }
}

/// {@template spaceship_bridge}
/// The main part of the [SpaceshipBridge], this [BodyComponent]
/// provides both the collision and the rotation animation for the bridge.
/// {@endtemplate}
class SpaceshipBridge extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_bridge}
  SpaceshipBridge() : super(priority: 3) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final sprite = await gameRef.images.load(
      Assets.images.components.spaceship.androidBottom.path,
    );
    await add(
      SpriteAnimationComponent.fromFrameData(
        sprite,
        SpriteAnimationData.sequenced(
          amount: 14,
          stepTime: 0.2,
          textureSize: Vector2(160, 114),
        ),
        size: Vector2.all((Spaceship.radius * 2) / 2.5),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = Spaceship.radius / 2.5;

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

  @override
  Shape get shape {
    const radius = Spaceship.radius * 2;
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
/// back to the board.
/// {@endtemplate}
class SpaceshipHole extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_hole}
  SpaceshipHole() {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    renderBody = false;
    final circleShape = CircleShape()..radius = Spaceship.radius / 40;

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

/// {@template spaceship_wall}
/// A [BodyComponent] that provides the collision for the wall
/// surrounding the spaceship, with a small opening to allow the
/// [Ball] to get inside the spaceship saucer.
/// It also contains the [SpriteComponent] for the lower wall
/// {@endtemplate}
class SpaceshipWall extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_wall}
  SpaceshipWall() : super(priority: 4) {
    layer = Layer.spaceship;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.components.spaceship.lower.path,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(Spaceship.radius * 2, Spaceship.radius + 1),
        anchor: Anchor.center,
        position: Vector2(-Spaceship.radius / 2, 0),
        angle: 90 * pi / 180,
      ),
    );
  }

  @override
  Body createBody() {
    renderBody = false;

    final wallShape = ChainShape()
      ..createChain(
        [
          for (var angle = 20; angle <= 340; angle++)
            Vector2(
              Spaceship.radius * cos(angle * pi / 180),
              Spaceship.radius * sin(angle * pi / 180),
            ),
        ],
      );

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..angle = 90 * pi / 180
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
      ..priority = 3
      ..gameRef.reorderChildren()
      ..layer = Layer.spaceship;
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipHole].
///
/// It resets the [Ball] priority and filter data so it will "be back" on the
/// board.
class SpaceshipHoleBallContactCallback
    extends ContactCallback<SpaceshipHole, Ball> {
  @override
  void begin(SpaceshipHole hole, Ball ball, _) {
    ball
      ..priority = 1
      ..gameRef.reorderChildren()
      ..layer = Layer.board;
  }
}
