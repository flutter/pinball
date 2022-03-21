import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template baseboard}
/// Straight, angled board piece to corral the [Ball] towards the [Flipper]s.
/// {@endtemplate}
class Baseboard extends BodyComponent with InitialPosition {
  /// {@macro baseboard}
  Baseboard({
    required BoardSide side,
  }) : _side = side;

  /// The width of the [Baseboard].
  static const width = 10.0;

  /// The height of the [Baseboard].
  static const height = 2.0;

  /// Whether the [Baseboard] is on the left or right side of the board.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final circleShape1 = CircleShape()..radius = Baseboard.height / 2;
    circleShape1.position.setValues(
      -(Baseboard.width / 2) + circleShape1.radius,
      0,
    );
    final circle1FixtureDef = FixtureDef(circleShape1);
    fixturesDef.add(circle1FixtureDef);

    final circleShape2 = CircleShape()..radius = Baseboard.height / 2;
    circleShape2.position.setValues(
      (Baseboard.width / 2) - circleShape2.radius,
      0,
    );
    final circle2FixtureDef = FixtureDef(circleShape2);
    fixturesDef.add(circle2FixtureDef);

    final rectangle = PolygonShape()
      ..setAsBoxXY(
        (Baseboard.width - Baseboard.height) / 2,
        Baseboard.height / 2,
      );
    final rectangleFixtureDef = FixtureDef(rectangle);
    fixturesDef.add(rectangleFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    // TODO(allisonryan0002): share sweeping angle with flipper when components
    // are grouped.
    const angle = math.pi / 7;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..angle = _side.isLeft ? -angle : angle;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
