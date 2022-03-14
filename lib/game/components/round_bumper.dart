import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template round_bumper}
/// Circular body that repels a [Ball] on contact, increasing the score.
/// {@endtemplate}
class RoundBumper extends BodyComponent with ScorePoints {
  /// {@macro round_bumper}
  RoundBumper({
    required Vector2 position,
    required double radius,
    required int points,
  })  : _position = position,
        _radius = radius,
        _points = points;

  /// The position of the [RoundBumper] body.
  final Vector2 _position;

  /// The radius of the [RoundBumper].
  final double _radius;

  /// Points awarded from hitting this [RoundBumper].
  final int _points;

  @override
  int get points => _points;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = _radius;

    final fixtureDef = FixtureDef(shape)..restitution = 1;

    final bodyDef = BodyDef()
      ..position = _position
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
