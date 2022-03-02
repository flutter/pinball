import 'package:flame_forge2d/flame_forge2d.dart';

class Plunger extends BodyComponent {
  Plunger(this._position);

  final Vector2 _position;

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(2.5, 1.5);

    final fixtureDef = FixtureDef(shape)..friction = 0.1;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  // Unused for now - from the previous kinematic plunger implementation.
  void pull() {
    body.linearVelocity = Vector2(0, -5);
  }

  // Unused for now - from the previous kinematic plunger implementation.
  void release() {
    final velocity = (_position.y - body.position.y) * 9;
    body.linearVelocity = Vector2(0, velocity);
  }
}
