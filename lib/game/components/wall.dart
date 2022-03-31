// ignore_for_file: avoid_renaming_method_parameters
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template wall}
/// A continuous generic and [BodyType.static] barrier that divides a game area.
/// {@endtemplate}
// TODO(alestiago): Remove [Wall] for [Pathway.straight].
class Wall extends BodyComponent {
  /// {@macro wall}
  Wall({
    required this.start,
    required this.end,
  });

  /// The [start] of the [Wall].
  final Vector2 start;

  /// The [end] of the [Wall].
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.1
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// Create top, left, and right [Wall]s for the game board.
List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft =
      PinballGame.boardBounds.topLeft.toVector2() + Vector2(18.6, 0);
  final bottomRight = PinballGame.boardBounds.bottomRight.toVector2();

  final topRight =
      PinballGame.boardBounds.topRight.toVector2() - Vector2(18.6, 0);
  final bottomLeft = PinballGame.boardBounds.bottomLeft.toVector2();

  return [
    Wall(start: topLeft, end: topRight),
    Wall(start: topRight, end: bottomRight),
    Wall(start: topLeft, end: bottomLeft),
  ];
}

/// {@template bottom_wall}
/// [Wall] located at the bottom of the board.
///
/// Collisions with [BottomWall] are listened by
/// [BottomWallBallContactCallback].
/// {@endtemplate}
class BottomWall extends Wall {
  /// {@macro bottom_wall}
  BottomWall()
      : super(
          start: PinballGame.boardBounds.bottomLeft.toVector2(),
          end: PinballGame.boardBounds.bottomRight.toVector2(),
        );
}

/// {@template bottom_wall_ball_contact_callback}
/// Listens when a [Ball] falls into a [BottomWall].
/// {@endtemplate}
class BottomWallBallContactCallback extends ContactCallback<Ball, BottomWall> {
  @override
  void begin(Ball ball, BottomWall wall, Contact contact) {
    // TODO(alestiago): replace with .firstChild when available.
    ball.children.whereType<BallController>().first.lost();
  }
}

/// {@template dino_top_wall}
/// Wall located above dino, at the right of the board.
/// {@endtemplate}
class DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  DinoTopWall() : super(priority: 2);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final wallPerspectiveAngle =
        PinballGame.boardPerspectiveAngle + math.pi / 2;

    final bottomCurveControlPoints = [
      Vector2(-8, 0),
      Vector2(-9, 1.5),
      Vector2(-8.5, 4),
      Vector2(-6.6, 7.5),
    ];
    final bottomCurveShape = BezierCurveShape(
      controlPoints: bottomCurveControlPoints,
    )..rotate(wallPerspectiveAngle);
    fixturesDef.add(FixtureDef(bottomCurveShape));

    final mediumCurveControlPoints = [
      bottomCurveControlPoints.last.clone(),
      Vector2(-4.3, 7),
      Vector2(-4.8, 4.2),
      Vector2(-1, 5),
    ];
    final mediumCurveShape = BezierCurveShape(
      controlPoints: mediumCurveControlPoints,
    )..rotate(wallPerspectiveAngle);
    fixturesDef.add(FixtureDef(mediumCurveShape));

    final topCurveControlPoints = [
      mediumCurveControlPoints.last.clone(),
      Vector2(1, 8.7),
      Vector2(6, 9.3),
      Vector2(13.5, 1),
    ];
    final topCurveShape = BezierCurveShape(
      controlPoints: topCurveControlPoints,
    )..rotate(wallPerspectiveAngle);
    fixturesDef.add(FixtureDef(topCurveShape));

    final topStraightPoints = [
      topCurveControlPoints.last.clone(),
      Vector2(13.5, 0),
    ];
    final topStraightShape = EdgeShape()
      ..set(
        topStraightPoints.first.clone()..rotate(wallPerspectiveAngle),
        topStraightPoints.last.clone()..rotate(wallPerspectiveAngle),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final wallStraightPoints = [
      bottomCurveControlPoints.first.clone(),
      topStraightPoints.last.clone(),
    ];
    final wallStraightShape = EdgeShape()
      ..set(
        wallStraightPoints.first..rotate(wallPerspectiveAngle),
        wallStraightPoints.last..rotate(wallPerspectiveAngle),
      );
    final wallStraightFixtureDef = FixtureDef(wallStraightShape);
    fixturesDef.add(wallStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(
      (fixture) => body.createFixture(
        fixture
          ..restitution = 0.1
          ..friction = 0,
      ),
    );

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadBackground();
  }

  Future<void> _loadBackground() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.components.dinoLandTop.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(10.6, 27.7),
      anchor: Anchor.center,
    )
      ..position = Vector2(-3, -5)
      ..priority = -1;

    await add(spriteComponent);
  }
}
