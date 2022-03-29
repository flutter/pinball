// ignore_for_file: avoid_renaming_method_parameters
import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball_components/pinball_components.dart';

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
    ball.controller.lost();
  }
}

/// {@template dino_top_wall}
/// Wall located above dino, at the right of the board.
/// {@endtemplate}
class DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  DinoTopWall() : super(priority: 2) {
    // TODO(ruimiguel): remove color once sprites are added.
    paint = Paint()
      ..color = const Color.fromARGB(255, 3, 188, 249)
      ..style = PaintingStyle.stroke;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final wallPerspectiveAngle =
        PinballGame.boardPerspectiveAngle + math.pi / 2;

    final topCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0, 0),
        Vector2(0, 8),
        Vector2(8, 8),
        Vector2(15, 0),
      ],
    )..rotate(wallPerspectiveAngle);
    final topFixtureDef = FixtureDef(topCurveShape)
      ..restitution = 0.1
      ..friction = 0;
    fixturesDef.add(topFixtureDef);

    final mediumCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0 - 5, 0),
        Vector2(0 - 5, 8),
        Vector2(3 - 5, 8),
        Vector2(7 - 5, 0),
      ],
    )..rotate(wallPerspectiveAngle);
    final mediumFixtureDef = FixtureDef(mediumCurveShape)
      ..restitution = 0.1
      ..friction = 0;
    fixturesDef.add(mediumFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

/// {@template dino_bottom_wall}
/// Wall located below dino, at the right of the board.
/// {@endtemplate}
class DinoBottomWall extends BodyComponent with InitialPosition {
  /// {@macro dino_bottom_wall}
  DinoBottomWall() : super(priority: 2) {
    // TODO(ruimiguel): remove color once sprites are added.
    paint = Paint()
      ..color = const Color.fromARGB(255, 3, 188, 249)
      ..style = PaintingStyle.stroke;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final wallPerspectiveAngle =
        PinballGame.boardPerspectiveAngle + math.pi / 2;

    final topVertices = [
      Vector2(0, 0),
      Vector2(0, 5),
      Vector2(-2, 8),
      Vector2(-10, 6),
      Vector2(-20, 4),
      Vector2(-20, 0),
    ]..forEach((point) {
        point.rotate(wallPerspectiveAngle);
      });
    final topWallShape = PolygonShape()..set(topVertices);
    final topWallFixtureDef = FixtureDef(topWallShape)
      ..restitution = 0.1
      ..friction = 0;
    fixturesDef.add(topWallFixtureDef);

    final bottomVertices = [
      Vector2(0 - 20, 0),
      Vector2(0 - 20, 4),
      Vector2(-40 - 20, 4),
      Vector2(-40 - 20, 0),
    ]..forEach((point) {
        point.rotate(wallPerspectiveAngle);
      });
    final bottomWallShape = PolygonShape()..set(bottomVertices);
    final bottomWallFixtureDef = FixtureDef(bottomWallShape)
      ..restitution = 0.1
      ..friction = 0;
    fixturesDef.add(bottomWallFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
