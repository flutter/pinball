// ignore_for_file: public_member_api_docs, avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// A [Blueprint] which creates the [JetpackRamp].
class Jetpack extends Forge2DBlueprint {
  /// {@macro spaceship}
  Jetpack();

  static const int ballPriorityInsideRamp = 4;

  @override
  void build(_) {
    addAllContactCallback([
      RampOpeningBallContactCallback<_JetpackRampOpening>(),
    ]);

    final rightOpening = _JetpackRampOpening(
      // TODO(ruimiguel): set Board priority when defined.
      outsidePriority: 1,
      rotation: math.pi,
    )
      ..initialPosition = Vector2(1.7, 19)
      ..layer = Layer.opening;
    final leftOpening = _JetpackRampOpening(
      outsideLayer: Layer.spaceship,
      outsidePriority: Spaceship.ballPriorityWhenOnSpaceship,
      rotation: math.pi,
    )
      ..initialPosition = Vector2(-13.7, 19)
      ..layer = Layer.jetpack;

    final jetpackRamp = JetpackRamp();

    final jetpackRampWallFg = _JetpackRampForegroundRailing();

    final baseRight = _JetpackBase()..initialPosition = Vector2(1.7, 20);

    addAll([
      rightOpening,
      leftOpening,
      baseRight,
      jetpackRamp,
      jetpackRampWallFg,
    ]);
  }
}

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp of the [Board].
/// {@endtemplate}
class JetpackRamp extends BodyComponent with InitialPosition, Layered {
  JetpackRamp() : super(priority: Jetpack.ballPriorityInsideRamp - 1) {
    layer = Layer.jetpack;
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
      Assets.images.components.spaceshipRamp.path,
    );

    final spriteRampComponent = SpriteComponent(
      sprite: spriteRamp,
      size: Vector2(38.1, 33.8),
      anchor: Anchor.center,
      position: Vector2(-12.2, -53.5),
    );

    final spriteRailingBg = await gameRef.loadSprite(
      Assets.images.components.spaceshipRailingBg.path,
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

class _JetpackRampForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  _JetpackRampForegroundRailing()
      : super(priority: Jetpack.ballPriorityInsideRamp + 1) {
    layer = Layer.jetpack;
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
      Assets.images.components.spaceshipRailingFg.path,
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

class _JetpackBase extends BodyComponent with InitialPosition, Layered {
  _JetpackBase() {
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

/// {@template jetpack_ramp_opening}
/// [RampOpening] with [Layer.jetpack] to filter [Ball] collisions
/// inside [JetpackRamp].
/// {@endtemplate}
class _JetpackRampOpening extends RampOpening {
  /// {@macro jetpack_ramp_opening}
  _JetpackRampOpening({
    Layer? outsideLayer,
    int? outsidePriority,
    required double rotation,
  })  : _rotation = rotation,
        super(
          insideLayer: Layer.jetpack,
          outsideLayer: outsideLayer,
          orientation: RampOrientation.down,
          insidePriority: Jetpack.ballPriorityInsideRamp,
          outsidePriority: outsidePriority,
        );

  final double _rotation;

  static final Vector2 _size = Vector2(JetpackRamp.width / 4, .1);

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
