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

    final triangleVertices = [
      Vector2(0, 0),
      Vector2(0, -10),
      Vector2(10, -10),
    ];
    final triangle = PolygonShape()..set(triangleVertices);
    fixtures.add(FixtureDef(triangle));

    final kickerVertices = [
      triangleVertices.first,
      triangleVertices.last,
    ];
    final kicker = PolygonShape()..set(kickerVertices);
    final kickerFixtureDef = FixtureDef(kicker)..restitution = 2.0;
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
