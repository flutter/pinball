import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart' as geometry show centroid;
import 'package:pinball/game/game.dart';

/// {@template sling_shot}
/// Triangular [BodyType.static] body that propels the [Ball] towards the
/// opposite side.
///
/// [SlingShot]s are usually positioned above each [Flipper].
/// {@endtemplate sling_shot}
class SlingShot extends BodyComponent with InitialPosition {
  /// {@macro sling_shot}
  SlingShot({
    required BoardSide side,
  }) : _side = side {
    // TODO(alestiago): Use sprite instead of color when provided.
    paint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;
  }

  /// Whether the [SlingShot] is on the left or right side of the board.
  ///
  /// A [SlingShot] with [BoardSide.left] propels the [Ball] to the right,
  /// whereas a [SlingShot] with [BoardSide.right] propels the [Ball] to the
  /// left.
  final BoardSide _side;

  /// The size of the [SlingShot] body.
  // TODO(alestiago): Use size from PositionedBodyComponent instead,
  // once a sprite is given.
  static final Vector2 size = Vector2(4, 10);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];
    final direction = _side.direction;
    const quarterPi = math.pi / 4;

    final upperCircle = CircleShape()..radius = 1.45;
    upperCircle.position.setValues(0, -upperCircle.radius / 2);
    final upperCircleFixtureDef = FixtureDef(upperCircle);
    fixturesDefs.add(upperCircleFixtureDef);

    final lowerCircle = CircleShape()..radius = 1.45;
    lowerCircle.position.setValues(
      size.x * -direction,
      -size.y,
    );
    final lowerCircleFixtureDef = FixtureDef(lowerCircle);
    fixturesDefs.add(lowerCircleFixtureDef);

    final wallFacingEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * direction,
              0,
            ),
        // TODO(alestiago): Use values from design.
        Vector2(2.0 * direction, -size.y + 2),
      );
    final wallFacingLineFixtureDef = FixtureDef(wallFacingEdge);
    fixturesDefs.add(wallFacingLineFixtureDef);

    final bottomEdge = EdgeShape()
      ..set(
        wallFacingEdge.vertex2,
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * direction,
              -lowerCircle.radius * math.sin(quarterPi),
            ),
      );
    final bottomLineFixtureDef = FixtureDef(bottomEdge);
    fixturesDefs.add(bottomLineFixtureDef);

    final kickerEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * math.cos(quarterPi) * -direction,
              upperCircle.radius * math.sin(quarterPi),
            ),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              lowerCircle.radius * math.sin(quarterPi),
            ),
      );

    final kickerFixtureDef = FixtureDef(kickerEdge)
      // TODO(alestiago): Play with restitution value once game is bundled.
      ..restitution = 10.0
      ..friction = 0;
    fixturesDefs.add(kickerFixtureDef);

    // TODO(alestiago): Evaluate if there is value on centering the fixtures.
    final centroid = geometry.centroid(
      [
        upperCircle.position + Vector2(0, -upperCircle.radius),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              -lowerCircle.radius * math.sin(quarterPi),
            ),
        wallFacingEdge.vertex2,
      ],
    );
    for (final fixtureDef in fixturesDefs) {
      if (fixtureDef.shape is EdgeShape) {
        final edge = fixtureDef.shape as EdgeShape;
        edge.set(edge.vertex1 - centroid, edge.vertex2 - centroid);
      } else if (fixtureDef.shape is CircleShape) {
        final circle = fixtureDef.shape as CircleShape;
        circle.position.setFrom(circle.position - centroid);
      }
    }

    return fixturesDefs;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
