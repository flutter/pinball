import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template round_bumper}
/// Circular body that repels a [Ball] on contact, increasing the score.
/// {@endtemplate}
class RoundBumper extends BodyComponent with ScorePoints, InitialPosition {
  /// {@macro round_bumper}
  RoundBumper({
    required double radius,
    required int points,
  })  : _radius = radius,
        _points = points;

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

    final bodyDef = BodyDef()..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
