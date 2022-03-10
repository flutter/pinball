import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// {@template sling_shot}
/// Triangular [BodyType.static] body that propels the [Ball] toward the
/// opposite side.
///
/// [SlingShot]s are usually positioned above each [Flipper].
/// {@endtemplate sling_shot}
class SlingShot extends BodyComponent {
  /// @{macro sling_shot}
  SlingShot({
    required Vector2 position,
  }) : _position = position {
    // TODO(alestiago): Use sprite instead of color when provided.
    paint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;
  }

  /// The initial position of the [SlingShot] body.
  final Vector2 _position;

  List<FixtureDef> _createFixtureDefs() {
    final fixtures = <FixtureDef>[];
    // TODO(alestiago): use size from [PositionBodyComponent].
    final size = Vector2(10, 10);

    final triangleVertices = [
      Vector2(0, 0),
      Vector2(0, -size.y),
      Vector2(size.x, -size.y),
    ];
    final triangleCentroid = centroid(triangleVertices);
    for (final vertex in triangleVertices) {
      vertex.setFrom(vertex - triangleCentroid);
    }

    final triangle = PolygonShape()..set(triangleVertices);
    fixtures.add(FixtureDef(triangle));

    final kicker = EdgeShape()
      ..set(
        triangleVertices.first,
        triangleVertices.last,
      );
    final kickerFixtureDef = FixtureDef(kicker)..restitution = 2.0;
    fixtures.add(kickerFixtureDef);

    return fixtures;
  }

  /// https://en.wikipedia.org/wiki/Centroid
  // TODO(alestiago): use from geometry package.
  static Vector2 centroid(List<Vector2> vertices) {
    final centroid = Vector2.zero();
    for (final vertex in vertices) {
      centroid.add(vertex);
    }
    return centroid / vertices.length.toDouble();
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = _position;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
