// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template spaceship_exit_rail}
/// A [Blueprint] for the spaceship drop tube.
/// {@endtemplate}
class SpaceshipExitRail extends Forge2DBlueprint {
  /// {@macro spaceship_exit_rail}
  SpaceshipExitRail();

  /// Base priority for wall while be on jetpack ramp.
  static const ballPriorityWhenOnSpaceshipExitRail = 2;

  @override
  void build(_) {
    addAllContactCallback([
      SpaceshipExitRailEndBallContactCallback(),
    ]);

    final exitRailRamp = _SpaceshipExitRailRamp();
    final exitRailEnd = SpaceshipExitRailEnd();
    final topBase = _SpaceshipExitRailBase(radius: 0.55)
      ..initialPosition = Vector2(-26.15, 18.65);
    final bottomBase = _SpaceshipExitRailBase(radius: 0.8)
      ..initialPosition = Vector2(-25.5, -12.9);

    addAll([
      exitRailRamp,
      exitRailEnd,
      topBase,
      bottomBase,
    ]);
  }
}

class _SpaceshipExitRailRamp extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailRamp()
      : super(
          priority: SpaceshipExitRail.ballPriorityWhenOnSpaceshipExitRail - 1,
        ) {
    renderBody = false;
    layer = Layer.spaceshipExitRail;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];

    final topArcShape = ArcShape(
      center: Vector2(-35.5, 30.9),
      arcRadius: 2.5,
      angle: math.pi,
      rotation: 2.9,
    );
    final topArcFixtureDef = FixtureDef(topArcShape);
    fixturesDefs.add(topArcFixtureDef);

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-37.9, 30.4),
        Vector2(-38, 23.9),
        Vector2(-30.93, 18.2),
      ],
    );
    final topLeftCurveFixtureDef = FixtureDef(topLeftCurveShape);
    fixturesDefs.add(topLeftCurveFixtureDef);

    final middleLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-30.93, 18.2),
        Vector2(-22.6, 10.3),
        Vector2(-30, 0.2),
      ],
    );
    final middleLeftCurveFixtureDef = FixtureDef(middleLeftCurveShape);
    fixturesDefs.add(middleLeftCurveFixtureDef);

    final bottomLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-30, 0.2),
        Vector2(-36, -8.6),
        Vector2(-32.04, -18.3),
      ],
    );
    final bottomLeftCurveFixtureDef = FixtureDef(bottomLeftCurveShape);
    fixturesDefs.add(bottomLeftCurveFixtureDef);

    final topRightStraightShape = EdgeShape()
      ..set(
        Vector2(-33, 31.3),
        Vector2(-27.2, 21.3),
      );
    final topRightStraightFixtureDef = FixtureDef(topRightStraightShape);
    fixturesDefs.add(topRightStraightFixtureDef);

    final middleRightCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-27.2, 21.3),
        Vector2(-16.5, 11.4),
        Vector2(-25.29, -1.7),
      ],
    );
    final middleRightCurveFixtureDef = FixtureDef(middleRightCurveShape);
    fixturesDefs.add(middleRightCurveFixtureDef);

    final bottomRightCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-25.29, -1.7),
        Vector2(-29.91, -8.5),
        Vector2(-26.8, -15.7),
      ],
    );
    final bottomRightCurveFixtureDef = FixtureDef(bottomRightCurveShape);
    fixturesDefs.add(bottomRightCurveFixtureDef);

    return fixturesDefs;
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
    await _loadSprite();
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.components.spaceshipDropTube.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(17.5, 55.7),
      anchor: Anchor.center,
      position: Vector2(-29.4, -5.7),
    );

    await add(spriteComponent);
  }
}

class _SpaceshipExitRailBase extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailBase({required this.radius})
      : super(
          priority: SpaceshipExitRail.ballPriorityWhenOnSpaceshipExitRail + 1,
        ) {
    renderBody = false;
    layer = Layer.board;
  }

  final double radius;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template spaceship_exit_rail_end}
/// A sensor [BodyComponent] responsible for sending the [Ball]
/// back to the board.
/// {@endtemplate}
class SpaceshipExitRailEnd extends RampOpening {
  /// {@macro spaceship_exit_rail_end}
  SpaceshipExitRailEnd()
      : super(
          insideLayer: Layer.spaceshipExitRail,
          orientation: RampOrientation.down,
        ) {
    renderBody = false;
    layer = Layer.spaceshipExitRail;
  }

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(-29, -17.8),
      arcRadius: 2.5,
      angle: math.pi * 0.8,
      rotation: -0.16,
    );
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipExitRailEnd].
///
/// It resets the [Ball] priority and filter data so it will "be back" on the
/// board.
class SpaceshipExitRailEndBallContactCallback
    extends ContactCallback<SpaceshipExitRailEnd, Ball> {
  @override
  void begin(SpaceshipExitRailEnd exitRail, Ball ball, _) {
    ball
      ..sendTo(exitRail.outsidePriority)
      ..layer = exitRail.outsideLayer;
  }
}
