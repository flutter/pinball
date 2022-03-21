import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart' show centroid;
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
  static final Vector2 size = Vector2(6, 8);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    // TODO(alestiago): This magic number can be deduced by specifying the
    // angle and using polar coordinate system to place the bottom right
    // vertex.
    // Something as: y = -size.y * math.cos(angle)
    const additionalIncrement = 3;
    final triangleVertices = _side.isLeft
        ? [
            Vector2(0, 0),
            Vector2(0, -size.y),
            Vector2(
              size.x,
              -size.y - additionalIncrement,
            ),
          ]
        : [
            Vector2(size.x, 0),
            Vector2(size.x, -size.y),
            Vector2(
              0,
              -size.y - additionalIncrement,
            ),
          ];
    final triangleCentroid = centroid(triangleVertices);
    for (final vertex in triangleVertices) {
      vertex.setFrom(vertex - triangleCentroid);
    }

    final triangle = PolygonShape()..set(triangleVertices);
    final triangleFixtureDef = FixtureDef(triangle)..friction = 0;
    fixturesDef.add(triangleFixtureDef);

    final kicker = EdgeShape()
      ..set(
        triangleVertices.first,
        triangleVertices.last,
      );
    // TODO(alestiago): Play with restitution value once game is bundled.
    final kickerFixtureDef = FixtureDef(kicker)
      ..restitution = 10.0
      ..friction = 0;
    fixturesDef.add(kickerFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
