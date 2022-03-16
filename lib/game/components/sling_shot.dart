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
class SlingShot extends BodyComponent {
  /// {@macro sling_shot}
  SlingShot({
    required Vector2 position,
    required BoardSide side,
  })  : _position = position,
        _side = side {
    // TODO(alestiago): Use sprite instead of color when provided.
    paint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;
  }

  /// The initial position of the [SlingShot] body.
  final Vector2 _position;

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
    final fixtures = <FixtureDef>[];

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
    fixtures.add(triangleFixtureDef);

    final kicker = EdgeShape()
      ..set(
        triangleVertices.first,
        triangleVertices.last,
      );
    // TODO(alestiago): Play with restitution value once game is bundled.
    final kickerFixtureDef = FixtureDef(kicker)
      ..restitution = 10.0
      ..friction = 0;
    fixtures.add(kickerFixtureDef);

    return fixtures;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = _position;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
