// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template spaceship_rail}
/// A [Blueprint] for the spaceship drop tube.
/// {@endtemplate}
class SpaceshipRail extends Forge2DBlueprint {
  /// {@macro spaceship_rail}
  SpaceshipRail();

  @override
  void build(_) {
    addAllContactCallback([
      LayerSensorBallContactCallback<_SpaceshipRailExit>(),
    ]);

    final railRamp = _SpaceshipRailRamp();
    final railEnd = _SpaceshipRailExit();
    final topBase = _SpaceshipRailBase(radius: 0.55)
      ..initialPosition = Vector2(-26.15, -18.65);
    final bottomBase = _SpaceshipRailBase(radius: 0.8)
      ..initialPosition = Vector2(-25.5, 12.9);
    final railForeground = _SpaceshipRailForeground();

    addAll([
      railRamp,
      railEnd,
      topBase,
      bottomBase,
      railForeground,
    ]);
  }
}

/// Represents the spaceship drop rail from the [Spaceship].
class _SpaceshipRailRamp extends BodyComponent with InitialPosition, Layered {
  _SpaceshipRailRamp() : super(priority: RenderPriority.spaceshipRail) {
    layer = Layer.spaceshipExitRail;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];

    final topArcShape = ArcShape(
      center: Vector2(-35.5, -30.9),
      arcRadius: 2.5,
      angle: math.pi,
      rotation: 0.2,
    );
    final topArcFixtureDef = FixtureDef(topArcShape);
    fixturesDefs.add(topArcFixtureDef);

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-37.9, -30.4),
        Vector2(-38, -23.9),
        Vector2(-30.93, -18.2),
      ],
    );
    final topLeftCurveFixtureDef = FixtureDef(topLeftCurveShape);
    fixturesDefs.add(topLeftCurveFixtureDef);

    final middleLeftCurveShape = BezierCurveShape(
      controlPoints: [
        topLeftCurveShape.vertices.last,
        Vector2(-22.6, -10.3),
        Vector2(-30, -0.2),
      ],
    );
    final middleLeftCurveFixtureDef = FixtureDef(middleLeftCurveShape);
    fixturesDefs.add(middleLeftCurveFixtureDef);

    final bottomLeftCurveShape = BezierCurveShape(
      controlPoints: [
        middleLeftCurveShape.vertices.last,
        Vector2(-36, 8.6),
        Vector2(-32.04, 18.3),
      ],
    );
    final bottomLeftCurveFixtureDef = FixtureDef(bottomLeftCurveShape);
    fixturesDefs.add(bottomLeftCurveFixtureDef);

    final topRightStraightShape = EdgeShape()
      ..set(
        Vector2(-33, -31.3),
        Vector2(-27.2, -21.3),
      );
    final topRightStraightFixtureDef = FixtureDef(topRightStraightShape);
    fixturesDefs.add(topRightStraightFixtureDef);

    final middleRightCurveShape = BezierCurveShape(
      controlPoints: [
        topRightStraightShape.vertex1,
        Vector2(-16.5, -11.4),
        Vector2(-25.29, 1.7),
      ],
    );
    final middleRightCurveFixtureDef = FixtureDef(middleRightCurveShape);
    fixturesDefs.add(middleRightCurveFixtureDef);

    final bottomRightCurveShape = BezierCurveShape(
      controlPoints: [
        middleRightCurveShape.vertices.last,
        Vector2(-29.91, 8.5),
        Vector2(-26.8, 15.7),
      ],
    );
    final bottomRightCurveFixtureDef = FixtureDef(bottomRightCurveShape);
    fixturesDefs.add(bottomRightCurveFixtureDef);

    return fixturesDefs;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    await add(_SpaceshipRailRampSpriteComponent());
  }
}

class _SpaceshipRailRampSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.rail.main.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(-29.4, -5.7);
  }
}

class _SpaceshipRailForeground extends SpriteComponent with HasGameRef {
  _SpaceshipRailForeground()
      : super(priority: RenderPriority.spaceshipRailForeground);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.rail.foreground.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(-28.5, 19.7);
  }
}

/// Represents the ground bases of the [_SpaceshipRailRamp].
class _SpaceshipRailBase extends BodyComponent with InitialPosition {
  _SpaceshipRailBase({required this.radius}) {
    renderBody = false;
  }

  final double radius;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _SpaceshipRailExit extends LayerSensor {
  _SpaceshipRailExit()
      : super(
          orientation: LayerEntranceOrientation.down,
          insideLayer: Layer.spaceshipExitRail,
          insidePriority: RenderPriority.ballOnSpaceshipRail,
        ) {
    renderBody = false;
    layer = Layer.spaceshipExitRail;
  }

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(-29, 19),
      arcRadius: 2.5,
      angle: math.pi * 0.4,
      rotation: -1.4,
    );
  }
}
