// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template spaceship_ramp}
/// A [Blueprint] which creates the ramp leading into the [Spaceship].
/// {@endtemplate}
class SpaceshipRamp extends Forge2DBlueprint {
  /// {@macro spaceship_ramp}
  SpaceshipRamp();

  /// Base priority for the [Ball] while inside the ramp.
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
      ..initialPosition = Vector2(1.7, 19.8)
      ..layer = Layer.opening;
    final leftOpening = _SpaceshipRampOpening(
      outsideLayer: Layer.spaceship,
      outsidePriority: Spaceship.ballPriorityWhenOnSpaceship,
      rotation: math.pi,
    )
      ..initialPosition = Vector2(-13.7, 18.6)
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
        Vector2(-30.75, 37.3),
        Vector2(-32.5, 71.25),
        Vector2(-14.2, 71.25),
      ],
    );

    final outerLeftCurveFixtureDef = FixtureDef(outerLeftCurveShape);
    fixturesDef.add(outerLeftCurveFixtureDef);

    final outerRightCurveShape = BezierCurveShape(
      controlPoints: [
        outerLeftCurveShape.vertices.last,
        Vector2(2.5, 71.9),
        Vector2(6.1, 44.9),
      ],
    );

    final outerRightCurveFixtureDef = FixtureDef(outerRightCurveShape);
    fixturesDef.add(outerRightCurveFixtureDef);

    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        outerRightCurveShape.vertices.last,
        Vector2(7.3, 41.1),
      );
    final boardOpeningEdgeShapeFixtureDef = FixtureDef(boardOpeningEdgeShape);
    fixturesDef.add(boardOpeningEdgeShapeFixtureDef);

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
      Assets.images.spaceship.ramp.main.keyName,
    );

    final spriteRampComponent = SpriteComponent(
      sprite: spriteRamp,
      size: spriteRamp.originalSize / 10,
      anchor: Anchor.center,
      position: Vector2(-10.6, -53.6),
    );

    final spriteRailingBg = await gameRef.loadSprite(
      Assets.images.spaceship.ramp.railingBackground.keyName,
    );
    final spriteRailingBgComponent = SpriteComponent(
      sprite: spriteRailingBg,
      size: spriteRailingBg.originalSize / 10,
      anchor: Anchor.center,
      position: spriteRampComponent.position + Vector2(-1.1, -0.7),
    );

    await addAll([
      spriteRampComponent,
      spriteRailingBgComponent,
    ]);
  }
}

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
        Vector2(-2.5, 66.2),
        Vector2(0, 44.5),
      ],
    );

    final innerRightCurveFixtureDef = FixtureDef(innerRightCurveShape);
    fixturesDef.add(innerRightCurveFixtureDef);

    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        innerRightCurveShape.vertices.last,
        Vector2(-0.85, 40.8),
      );
    final boardOpeningEdgeShapeFixtureDef = FixtureDef(boardOpeningEdgeShape);
    fixturesDef.add(boardOpeningEdgeShapeFixtureDef);

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
      Assets.images.spaceship.ramp.railingForeground.keyName,
    );
    final spriteRailingFgComponent = SpriteComponent(
      sprite: spriteRailingFg,
      size: spriteRailingFg.originalSize / 10,
      anchor: Anchor.center,
      position: Vector2(-12.3, -52.5),
    );

    await add(spriteRailingFgComponent);
  }
}

class _SpaceshipRampBase extends BodyComponent with InitialPosition, Layered {
  _SpaceshipRampBase() {
    layer = Layer.board;
  }

  @override
  Body createBody() {
    renderBody = false;

    const baseWidth = 9;
    final baseShape = BezierCurveShape(
      controlPoints: [
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y),
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y) +
            Vector2(2, 5),
        Vector2(initialPosition.x + baseWidth / 2, initialPosition.y) +
            Vector2(-2, 5),
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

  static final Vector2 _size = Vector2(_SpaceshipRampBackground.width / 3, .1);

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
