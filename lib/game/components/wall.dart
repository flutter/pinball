// ignore_for_file: avoid_renaming_method_parameters
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
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
  final topLeft = BoardDimensions.bounds.topLeft.toVector2() + Vector2(18.6, 0);
  final bottomRight = BoardDimensions.bounds.bottomRight.toVector2();

  final topRight =
      BoardDimensions.bounds.topRight.toVector2() - Vector2(18.6, 0);
  final bottomLeft = BoardDimensions.bounds.bottomLeft.toVector2();

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
          start: BoardDimensions.bounds.bottomLeft.toVector2(),
          end: BoardDimensions.bounds.bottomRight.toVector2(),
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

    final topStraightControlPoints = [
      Vector2(29.5, 35.1),
      Vector2(28.4, 35.1),
    ];
    final topStraightShape = EdgeShape()
      ..set(
        topStraightControlPoints.first,
        topStraightControlPoints.last,
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final topCurveControlPoints = [
      topStraightControlPoints.last,
      Vector2(17.4, 26.38),
      Vector2(25.5, 20.7),
    ];
    final topCurveShape = BezierCurveShape(
      controlPoints: topCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(topCurveShape));

    final middleCurveControlPoints = [
      topCurveControlPoints.last,
      Vector2(27.8, 20.1),
      Vector2(26.8, 19.5),
    ];
    final middleCurveShape = BezierCurveShape(
      controlPoints: middleCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(middleCurveShape));

    final bottomCurveControlPoints = [
      middleCurveControlPoints.last,
      Vector2(21.15, 16),
      Vector2(25.6, 15.2),
    ];
    final bottomCurveShape = BezierCurveShape(
      controlPoints: bottomCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(bottomCurveShape));

    final bottomStraightControlPoints = [
      bottomCurveControlPoints.last,
      Vector2(31, 14.5),
    ];
    final bottomStraightShape = EdgeShape()
      ..set(
        bottomStraightControlPoints.first,
        bottomStraightControlPoints.last,
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

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
    )..position = Vector2(27, -28.2);

    await add(spriteComponent);
  }
}
