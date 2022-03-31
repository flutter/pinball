// ignore_for_file: public_member_api_docs, avoid_renaming_method_parameters

import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// A [Blueprint] which creates the [JetpackRamp].
class Jetpack extends Forge2DBlueprint {
  /// {@macro spaceship}
  Jetpack({required this.position});

  /// The [position] where the elements will be created
  final Vector2 position;

  @override
  void build(_) {
    addAllContactCallback([
      RampOpeningBallContactCallback<_JetpackRampOpening>(),
    ]);

    final rightOpening = _JetpackRampOpening(
      rotation: math.pi,
    )
      ..initialPosition = position + Vector2(1.7, 19)
      ..layer = Layer.opening;
    final leftOpening = _JetpackRampOpening(
      outsideLayer: Layer.spaceship,
      rotation: math.pi,
    )
      ..initialPosition = position + Vector2(-13.7, 19)
      ..layer = Layer.jetpack;

    final jetpackRamp = JetpackRamp()
      ..initialPosition = position
      ..layer = Layer.jetpack;

    final baseRight = _JetpackBase()
      ..initialPosition = position + Vector2(1.7, 20);

    addAll([
      rightOpening,
      leftOpening,
      jetpackRamp,
      baseRight,
    ]);
  }
}

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp of the [Board].
/// {@endtemplate}
class JetpackRamp extends BodyComponent with InitialPosition, Layered {
  JetpackRamp() : super(priority: 3) {
    layer = Layer.jetpack;
    paint = Paint()
      ..color = Color.fromARGB(255, 0, 217, 255)
      ..style = PaintingStyle.stroke;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final innerLeftControlPoints = [
      Vector2(-24.73, 38),
      Vector2(-26.3, 65.65),
      Vector2(-13.8, 65.65),
    ];
    final innerLeftCurveShape = BezierCurveShape(
      controlPoints: innerLeftControlPoints,
    );

    final innerLeftCurveFixtureDef = FixtureDef(innerLeftCurveShape);
    fixturesDef.add(innerLeftCurveFixtureDef);

    final innerRightControlPoints = [
      innerLeftControlPoints.last,
      Vector2(-1, 65.9),
      Vector2(0.1, 39.5),
    ];
    final innerRightCurveShape = BezierCurveShape(
      controlPoints: innerRightControlPoints,
    );

    final innerRightCurveFixtureDef = FixtureDef(innerRightCurveShape);
    fixturesDef.add(innerRightCurveFixtureDef);

    final outerLeftControlPoints = [
      Vector2(-30.95, 38),
      Vector2(-33, 71.25),
      Vector2(-14.2, 71.25),
    ];
    final outerLeftCurveShape = BezierCurveShape(
      controlPoints: outerLeftControlPoints,
    );

    final outerLeftCurveFixtureDef = FixtureDef(outerLeftCurveShape);
    fixturesDef.add(outerLeftCurveFixtureDef);

    final outerRightControlPoints = [
      outerLeftControlPoints.last,
      Vector2(4.7, 71.25),
      Vector2(6.3, 40.1),
    ];
    final outerRightCurveShape = BezierCurveShape(
      controlPoints: outerRightControlPoints,
    );

    final outerRightCurveFixtureDef = FixtureDef(outerRightCurveShape);
    fixturesDef.add(outerRightCurveFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
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
    //await _loadBackground();
  }

  Future<void> _loadBackground() async {
    final spriteRamp = await gameRef.loadSprite(
      Assets.images.components.spaceshipRamp.path,
    );

    final spriteRampComponent = SpriteComponent(
      sprite: spriteRamp,
      size: Vector2(38.1, 33.8),
      anchor: Anchor.center,
    )
      ..position = Vector2(-12.2, -53.5)
      ..priority = 2;

    final spriteRailingBg = await gameRef.loadSprite(
      Assets.images.components.spaceshipRailingBg.path,
    );
    final spriteRailingBgComponent = SpriteComponent(
      sprite: spriteRailingBg,
      size: Vector2(38.3, 35.1),
      anchor: Anchor.center,
    )
      ..position = spriteRampComponent.position + Vector2(0, -1)
      ..priority = 3;

    final spriteRailingFg = await gameRef.loadSprite(
      Assets.images.components.spaceshipRailingFg.path,
    );
    final spriteRailingFgComponent = SpriteComponent(
      sprite: spriteRailingFg,
      size: Vector2(26.1, 28.3),
      anchor: Anchor.center,
    )
      ..position = spriteRampComponent.position + Vector2(0, 1)
      ..priority = 5;

    await add(spriteRailingBgComponent);
    await add(spriteRampComponent);
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

    final baseShape = BezierCurveShape(
      controlPoints: [
        Vector2(initialPosition.x - 3, initialPosition.y),
        Vector2(initialPosition.x - 3, initialPosition.y) + Vector2(2, 2),
        Vector2(initialPosition.x + 3, initialPosition.y) + Vector2(-2, 2),
        Vector2(initialPosition.x + 3, initialPosition.y)
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
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.jetpack,
          outsideLayer: outsideLayer,
          orientation: RampOrientation.down,
          pathwayPriority: 4,
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
