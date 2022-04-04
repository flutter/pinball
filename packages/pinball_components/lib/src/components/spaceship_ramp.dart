// ignore_for_file: avoid_renaming_method_parameters, comment_references

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template spaceship_ramp}
/// A [Blueprint] which creates the [_SpaceshipRampBackground].
/// {@endtemplate}
class SpaceshipRamp extends Forge2DBlueprint {
  /// {@macro spaceship_ramp}
  SpaceshipRamp();

  /// Base priority for wall while be in the ramp.
  static const int ballPriorityInsideRamp = 4;

  @override
  void build(_) {
    addAllContactCallback([
      RampOpeningBallContactCallback<_SpaceshipRampOpening>(),
    ]);

    final rightOpening = _SpaceshipRampOpening(
      // TODO(ruimiguel): set Board priority when defined.
      outsidePriority: 1,
      rotation: math.pi,
    )
      ..initialPosition = Vector2(1.7, 19)
      ..layer = Layer.opening;
    final leftOpening = _SpaceshipRampOpening(
      outsideLayer: Layer.spaceship,
      outsidePriority: Spaceship.ballPriorityWhenOnSpaceship,
      rotation: math.pi,
    )
      ..initialPosition = Vector2(-13.7, 19)
      ..layer = Layer.spaceshipEntranceRamp;

    final spaceshipRamp = _SpaceshipRampBackground();

    final spaceshipRampForegroundRailing = _SpaceshipRampForegroundRailing();

    final baseRight = _SpaceshipRampBase()..initialPosition = Vector2(1.7, 20);

    addAll([
      rightOpening,
      leftOpening,
      baseRight,
      spaceshipRamp,
      spaceshipRampForegroundRailing,
    ]);
  }
}

/// Represents the upper left blue ramp of the [Board] with its background
/// railing.
class _SpaceshipRampBackground extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampBackground()
      : super(priority: SpaceshipRamp.ballPriorityInsideRamp - 1) {
    layer = Layer.spaceshipEntranceRamp;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final outerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-30.95, 38),
        Vector2(-32.5, 71.25),
        Vector2(-14.2, 71.25),
      ],
    );

    final outerLeftCurveFixtureDef = FixtureDef(outerLeftCurveShape);
    fixturesDef.add(outerLeftCurveFixtureDef);

    final outerRightCurveShape = BezierCurveShape(
      controlPoints: [
        outerLeftCurveShape.vertices.last,
        Vector2(4.7, 71.25),
        Vector2(6.3, 40),
      ],
    );

    final outerRightCurveFixtureDef = FixtureDef(outerRightCurveShape);
    fixturesDef.add(outerRightCurveFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();
  }

  Future<void> _loadSprites() async {
    final spriteRamp = await gameRef.loadSprite(
      Assets.images.spaceshipRamp.spaceshipRamp.keyName,
    );

    final spriteRampComponent = SpriteComponent(
      sprite: spriteRamp,
      size: Vector2(38.1, 33.8),
      anchor: Anchor.center,
      position: Vector2(-12.2, -53.5),
    );

    final spriteRailingBg = await gameRef.loadSprite(
      Assets.images.spaceshipRamp.spaceshipRailingBg.keyName,
    );
    final spriteRailingBgComponent = SpriteComponent(
      sprite: spriteRailingBg,
      size: Vector2(38.3, 35.1),
      anchor: Anchor.center,
      position: spriteRampComponent.position + Vector2(0, -1),
    );

    await addAll([
      spriteRailingBgComponent,
      spriteRampComponent,
    ]);
  }
}

/// Represents the foreground of the railing upper left blue ramp.
class _SpaceshipRampForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampForegroundRailing()
      : super(priority: SpaceshipRamp.ballPriorityInsideRamp + 1) {
    layer = Layer.spaceshipEntranceRamp;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final innerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-24.5, 38),
        Vector2(-26.3, 64),
        Vector2(-13.8, 64.5),
      ],
    );

    final innerLeftCurveFixtureDef = FixtureDef(innerLeftCurveShape);
    fixturesDef.add(innerLeftCurveFixtureDef);

    final innerRightCurveShape = BezierCurveShape(
      controlPoints: [
        innerLeftCurveShape.vertices.last,
        Vector2(-1, 64.5),
        Vector2(0.1, 39.5),
      ],
    );

    final innerRightCurveFixtureDef = FixtureDef(innerRightCurveShape);
    fixturesDef.add(innerRightCurveFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();
  }

  Future<void> _loadSprites() async {
    final spriteRailingFg = await gameRef.loadSprite(
      Assets.images.spaceshipRamp.spaceshipRailingFg.keyName,
    );
    final spriteRailingFgComponent = SpriteComponent(
      sprite: spriteRailingFg,
      size: Vector2(26.1, 28.3),
      anchor: Anchor.center,
      position: Vector2(-12.2, -52.5),
    );

    await add(spriteRailingFgComponent);
  }
}

/// Represents the ground right base of the [SpaceshipRamp].
class _SpaceshipRampBase extends BodyComponent with InitialPosition, Layered {
  _SpaceshipRampBase() {
    layer = Layer.board;
  }

  @override
  Body createBody() {
    renderBody = false;

    const baseWidth = 6;
    final baseShape = BezierCurveShape(
      controlPoints: [
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y),
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y) +
            Vector2(2, 2),
        Vector2(initialPosition.x + baseWidth / 2, initialPosition.y) +
            Vector2(-2, 2),
        Vector2(initialPosition.x + baseWidth / 2, initialPosition.y)
      ],
    );
    final fixtureDef = FixtureDef(baseShape);

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template spaceship_ramp_opening}
/// [RampOpening] with [Layer.spaceshipEntranceRamp] to filter [Ball] collisions
/// inside [_SpaceshipRampBackground].
/// {@endtemplate}
class _SpaceshipRampOpening extends RampOpening {
  /// {@macro spaceship_ramp_opening}
  _SpaceshipRampOpening({
    Layer? outsideLayer,
    int? outsidePriority,
    required double rotation,
  })  : _rotation = rotation,
        super(
          insideLayer: Layer.spaceshipEntranceRamp,
          outsideLayer: outsideLayer,
          orientation: RampOrientation.down,
          insidePriority: SpaceshipRamp.ballPriorityInsideRamp,
          outsidePriority: outsidePriority,
        );

  final double _rotation;

  static final Vector2 _size = Vector2(_SpaceshipRampBackground.width / 4, .1);

  @override
  Shape get shape {
    renderBody = false;
    return PolygonShape()
      ..setAsBox(
        _size.x,
        _size.y,
        initialPosition,
        _rotation,
      );
  }
}
