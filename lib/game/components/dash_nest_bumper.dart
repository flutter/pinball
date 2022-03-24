import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template dash_nest_bumper}
/// Circular body that repels a [Ball] on contact, increasing the score.
/// {@endtemplate}
class DashNestBumper extends BodyComponent with ScorePoints, InitialPosition {
  /// {@macro dash_nest_bumper}
  DashNestBumper({
    required double radius,
    required int points,
  })  : _radius = radius,
        _points = points;

  /// The radius of the [DashNestBumper].
  final double _radius;

  /// Points awarded from hitting this [DashNestBumper].
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
