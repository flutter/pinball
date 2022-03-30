// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template spaceship_exit_rail}
/// A [Blueprint] for the spaceship drop tube.
/// {@endtemplate}
class SpaceshipExitRail extends Forge2DBlueprint {
  /// {@macro spaceship_exit_rail}
  SpaceshipExitRail({required this.position});

  /// The [position] where the elements will be created
  final Vector2 position;

  @override
  void build(_) {
    addAllContactCallback([
      SpaceshipExitRailEndBallContactCallback(),
    ]);

    final spaceshipExitRailRamp = _SpaceshipExitRailRamp()
      ..initialPosition = position;
    final exitRail = SpaceshipExitRailEnd()
      ..initialPosition = position + _SpaceshipExitRailRamp.exitPoint;
    final topBase = _SpaceshipExitRailBase(radius: 0.55)
      ..initialPosition = position + Vector2(12, -11.5);
    final bottomBase = _SpaceshipExitRailBase(radius: 0.8)
      ..initialPosition = position + Vector2(12.8, -43.5);
    addAll([
      spaceshipExitRailRamp,
      exitRail,
      topBase,
      bottomBase,
    ]);
  }
}

class _SpaceshipExitRailRamp extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailRamp() : super(priority: 2) {
    renderBody = false;
    layer = Layer.spaceshipExitRail;
  }

  static final exitPoint = Vector2(9.2, -48.5);

  List<FixtureDef> _createFixtureDefs() {
    const entranceRotationAngle = 175 * math.pi / 180;
    const curveRotationAngle = 275 * math.pi / 180;
    const exitRotationAngle = 340 * math.pi / 180;
    const width = 5.5;

    final fixturesDefs = <FixtureDef>[];

    final entranceWall = ArcShape(
      center: Vector2(width / 2, 0),
      arcRadius: width / 2,
      angle: math.pi,
      rotation: entranceRotationAngle,
    );
    final entranceFixtureDef = FixtureDef(entranceWall);
    fixturesDefs.add(entranceFixtureDef);

    final topLeftControlPoints = [
      Vector2(0, 0),
      Vector2(10, .5),
      Vector2(7, 4),
      Vector2(15.5, 8.3),
    ];
    final topLeftCurveShape = BezierCurveShape(
      controlPoints: topLeftControlPoints,
    )..rotate(curveRotationAngle);
    final topLeftFixtureDef = FixtureDef(topLeftCurveShape);
    fixturesDefs.add(topLeftFixtureDef);

    final topRightControlPoints = [
      Vector2(0, width),
      Vector2(10, 6.5),
      Vector2(7, 10),
      Vector2(15.5, 13.2),
    ];
    final topRightCurveShape = BezierCurveShape(
      controlPoints: topRightControlPoints,
    )..rotate(curveRotationAngle);
    final topRightFixtureDef = FixtureDef(topRightCurveShape);
    fixturesDefs.add(topRightFixtureDef);

    final mediumLeftControlPoints = [
      topLeftControlPoints.last,
      Vector2(21, 12.9),
      Vector2(30, 7.1),
      Vector2(32, 4.8),
    ];
    final mediumLeftCurveShape = BezierCurveShape(
      controlPoints: mediumLeftControlPoints,
    )..rotate(curveRotationAngle);
    final mediumLeftFixtureDef = FixtureDef(mediumLeftCurveShape);
    fixturesDefs.add(mediumLeftFixtureDef);

    final mediumRightControlPoints = [
      topRightControlPoints.last,
      Vector2(21, 17.2),
      Vector2(30, 12.1),
      Vector2(32, 10.2),
    ];
    final mediumRightCurveShape = BezierCurveShape(
      controlPoints: mediumRightControlPoints,
    )..rotate(curveRotationAngle);
    final mediumRightFixtureDef = FixtureDef(mediumRightCurveShape);
    fixturesDefs.add(mediumRightFixtureDef);

    final bottomLeftControlPoints = [
      mediumLeftControlPoints.last,
      Vector2(40, -1),
      Vector2(48, 1.9),
      Vector2(50.5, 2.5),
    ];
    final bottomLeftCurveShape = BezierCurveShape(
      controlPoints: bottomLeftControlPoints,
    )..rotate(curveRotationAngle);
    final bottomLeftFixtureDef = FixtureDef(bottomLeftCurveShape);
    fixturesDefs.add(bottomLeftFixtureDef);

    final bottomRightControlPoints = [
      mediumRightControlPoints.last,
      Vector2(40, 4),
      Vector2(46, 6.5),
      Vector2(48.8, 7.6),
    ];
    final bottomRightCurveShape = BezierCurveShape(
      controlPoints: bottomRightControlPoints,
    )..rotate(curveRotationAngle);
    final bottomRightFixtureDef = FixtureDef(bottomRightCurveShape);
    fixturesDefs.add(bottomRightFixtureDef);

    final exitWall = ArcShape(
      center: exitPoint,
      arcRadius: width / 2,
      angle: math.pi,
      rotation: exitRotationAngle,
    );
    final exitFixtureDef = FixtureDef(exitWall);
    fixturesDefs.add(exitFixtureDef);

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
    await _loadBackground();
  }

  Future<void> _loadBackground() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.components.spaceshipDropTube.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(17.5, 55.7),
      anchor: Anchor.center,
    )
      ..position = Vector2(8.7, 24.5)
      ..priority = 2;

    await add(spriteComponent);
  }
}

class _SpaceshipExitRailBase extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailBase({required this.radius}) : super(priority: 5) {
    layer = Layer.board;
  }

  final double radius;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.static;

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
          pathwayLayer: Layer.spaceshipExitRail,
          orientation: RampOrientation.down,
        ) {
    renderBody = false;
    layer = Layer.spaceshipExitRail;
  }

  @override
  Shape get shape {
    return CircleShape()..radius = 1;
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
      ..priority = 1
      ..gameRef.reorderChildren()
      ..layer = exitRail.outsideLayer;
  }
}
