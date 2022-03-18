// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

// TODO(erickzanardo): change this to use the layer class
// that will be introduced on the path PR
const _spaceShipBits = 0x0002;
const _spaceShipSize = 20.0;

/// {@template spaceship_sauce}
/// A [BodyComponent] for the base, or the sauce of the spaceship
/// {@endtemplate}
class SpaceshipSauce extends BodyComponent with InitialPosition {
  /// {@macro spaceship_sauce}
  SpaceshipSauce() : super(priority: 2);

  /// Path for the base sprite
  static const sauceSpritePath = 'components/spaceship/sauce.png';

  /// Path for the upper wall sprite
  static const upperWallPath = 'components/spaceship/upper.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = await Future.wait([
      gameRef.loadSprite(sauceSpritePath),
      gameRef.loadSprite(upperWallPath),
    ]);

    await add(
      SpriteComponent(
        sprite: sprites.first,
        size: Vector2.all(_spaceShipSize),
        anchor: Anchor.center,
      ),
    );

    await add(
      SpriteComponent(
        sprite: sprites.last,
        size: Vector2(_spaceShipSize + 0.5, _spaceShipSize / 2),
        anchor: Anchor.center,
        position: Vector2(0, -(_spaceShipSize / 3.5)),
      ),
    );

    renderBody = false;
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = _spaceShipSize / 2;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)
          ..isSensor = true
          ..filter.maskBits = _spaceShipBits
          ..filter.categoryBits = _spaceShipBits,
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

  /// Path to the top of this sprite
  static const spritePath = 'components/spaceship/android-top.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(spritePath);
    await add(
      SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        size: Vector2(_spaceShipSize / 2.5 - 1, _spaceShipSize / 5),
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
class SpaceshipBridge extends BodyComponent with InitialPosition {
  /// {@macro spaceship_bridge}
  SpaceshipBridge() : super(priority: 3);

  /// Path to the spaceship bridge
  static const spritePath = 'components/spaceship/android-bottom.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final sprite = await gameRef.images.load(spritePath);
    await add(
      SpriteAnimationComponent.fromFrameData(
        sprite,
        SpriteAnimationData.sequenced(
          amount: 14,
          stepTime: 0.2,
          textureSize: Vector2(160, 114),
        ),
        size: Vector2.all(_spaceShipSize / 2.5),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = _spaceShipSize / 5;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)
          ..restitution = 0.4
          ..filter.maskBits = _spaceShipBits
          ..filter.categoryBits = _spaceShipBits,
      );
  }
}

/// {@template spaceship_entrance}
/// A sensor [BodyComponent] used to detect when the ball enters the
/// the spaceship area in order to modify its filter data so the ball
/// can correctly collide only with the Spaceship
/// {@endtemplate}
class SpaceshipEntrance extends BodyComponent with InitialPosition {
  /// {@macro spaceship_entrance}
  SpaceshipEntrance();

  @override
  Body createBody() {
    const r = _spaceShipSize / 2;
    final entranceShape = PolygonShape()
      ..setAsEdge(
        Vector2(
          r * cos(20 * pi / 180),
          r * sin(20 * pi / 180),
        ),
        Vector2(
          r * cos(340 * pi / 180),
          r * sin(340 * pi / 180),
        ),
      );

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..angle = 90 * pi / 180
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(entranceShape)..isSensor = true,
      );
  }
}

/// {@template spaceship_hole}
/// A sensor [BodyComponent] responsible for sending the [Ball]
/// back to the board.
/// {@endtemplate}
class SpaceshipHole extends BodyComponent with InitialPosition {
  /// {@macro spaceship_hole}
  SpaceshipHole();

  @override
  Body createBody() {
    renderBody = false;
    final circleShape = CircleShape()..radius = _spaceShipSize / 80;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(circleShape)
          ..isSensor = true
          ..filter.maskBits = _spaceShipBits
          ..filter.categoryBits = _spaceShipBits,
      );
  }
}

/// {@template spaceship_wall}
/// A [BodyComponent] that provides the collision for the wall
/// surrounding the spaceship, with a small opening to allow the
/// [Ball] to get inside the spaceship sauce.
/// It also contains the [SpriteComponent] for the lower wall
/// {@endtemplate}
class SpaceshipWall extends BodyComponent with InitialPosition {
  /// {@macro spaceship_wall}
  SpaceshipWall() : super(priority: 4);

  /// Sprite path for the lower wall
  static const lowerWallPath = 'components/spaceship/lower.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(lowerWallPath);

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(_spaceShipSize, (_spaceShipSize / 2) + 1),
        anchor: Anchor.center,
        position: Vector2(-_spaceShipSize / 4, 0),
        angle: 90 * pi / 180,
      ),
    );
  }

  @override
  Body createBody() {
    renderBody = false;

    const r = _spaceShipSize / 2;

    final wallShape = ChainShape()
      ..createChain(
        [
          for (var a = 20; a <= 340; a++)
            Vector2(
              r * cos(a * pi / 180),
              r * sin(a * pi / 180),
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
        FixtureDef(wallShape)
          ..restitution = 1 
          ..filter.maskBits = _spaceShipBits
          ..filter.categoryBits = _spaceShipBits,
      );
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and the [SpaceshipEntrance], it modifies the [Ball] priority
/// and filter data so it can appear on top of the spaceship and
/// also only collide with the spaceship
class SpaceshipEntranceBallContactCallback
    extends ContactCallback<SpaceshipEntrance, Ball> {
  @override
  void begin(SpaceshipEntrance entrance, Ball ball, Contact contact) {
    ball
      ..priority = 3
      ..gameRef.reorderChildren();

    for (final fixture in ball.body.fixtures) {
      fixture.filterData.categoryBits = _spaceShipBits;
      fixture.filterData.maskBits = _spaceShipBits;
    }
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipHole], it will reset the [Ball] priority and
/// filter data so it will "be back" on the board
class SpaceshipHoleBallContactCallback
    extends ContactCallback<SpaceshipHole, Ball> {
  @override
  void begin(SpaceshipHole hole, Ball ball, Contact contact) {
    ball.priority = 1;
    ball.gameRef.reorderChildren();

    for (final fixture in ball.body.fixtures) {
      fixture.filterData.categoryBits = 0xFFFF;
      fixture.filterData.maskBits = 0x0001;
    }
  }
}
