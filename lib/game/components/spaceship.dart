// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

const _spaceShipBits = 0x0002;

class Spaceship extends Component {
  static const size = 20.0;
}

class SpaceshipSauce extends BodyComponent {
  SpaceshipSauce(this.position) : super(priority: 2);

  // TODO change to initial position

  final Vector2 position;

  static const sauceSpritePath = 'components/spaceship/sauce.png';
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
        size: Vector2.all(Spaceship.size),
        anchor: Anchor.center,
      ),
    );

    await add(
      SpriteComponent(
        sprite: sprites.last,
        size: Vector2(Spaceship.size + 0.5, Spaceship.size / 2),
        anchor: Anchor.center,
        position: Vector2(0, -(Spaceship.size / 3.5)),
      ),
    );

    renderBody = false;
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = Spaceship.size / 2;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
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

class SpaceshipBridgeTop extends BodyComponent {
  SpaceshipBridgeTop(
    this.position,
  ) : super(priority: 6);

  // TODO change to initial position
  final Vector2 position;

  static const spritePath = 'components/spaceship/android-top.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(spritePath);
    await add(
      SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        size: Vector2(Spaceship.size / 2.5 - 1, Spaceship.size / 5),
      ),
    );
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = position + Vector2(0, 5.5)
      ..type = BodyType.static;

    return world.createBody(bodyDef);
  }
}

class SpaceshipEntrance extends BodyComponent {
  SpaceshipEntrance(this.position);

  // TODO change to initial position

  final Vector2 position;

  @override
  Body createBody() {
    const r = Spaceship.size / 2;
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
      ..position = position
      ..angle = 90 * pi / 180
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(entranceShape)..isSensor = true,
      );
  }
}

class SpaceshipBridge extends BodyComponent {
  SpaceshipBridge(this.position) : super(priority: 3);

  // TODO change to initial position
  final Vector2 position;

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
        size: Vector2.all(Spaceship.size / 2.5),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final circleShape = CircleShape()..radius = Spaceship.size / 5;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
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

class SpaceshipHole extends BodyComponent {
  SpaceshipHole(this.position);

  // TODO change to initial position
  final Vector2 position;

  @override
  Body createBody() {
    renderBody = false;
    final circleShape = CircleShape()..radius = Spaceship.size / 14;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
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

class SpaceshipWall extends BodyComponent {
  SpaceshipWall(this.position) : super(priority: 4);

  // TODO change to initial position

  final Vector2 position;

  static const lowerWallPath = 'components/spaceship/lower.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(lowerWallPath);

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(Spaceship.size, (Spaceship.size / 2) + 1),
        anchor: Anchor.center,
        position: Vector2(-Spaceship.size / 4, 0),
        angle: 90 * pi / 180,
      ),
    );
  }

  @override
  Body createBody() {
    renderBody = false;

    const r = Spaceship.size / 2;

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
      ..position = position
      ..angle = 90 * pi / 180
      ..type = BodyType.static;

    return world.createBody(bodyDef)
      ..createFixture(
        FixtureDef(wallShape)
          ..restitution = 0.8
          ..filter.maskBits = _spaceShipBits
          ..filter.categoryBits = _spaceShipBits,
      );
  }
}

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
