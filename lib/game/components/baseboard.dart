import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template baseboard}
/// Wing-shaped board piece to corral the [Ball] towards the [Flipper]s.
/// {@endtemplate}
class Baseboard extends BodyComponent with InitialPosition {
  /// {@macro baseboard}
  Baseboard({
    required BoardSide side,
  }) : _side = side;

  /// The size of the [Baseboard].
  static final size = Vector2(24.2, 13.5);

  /// Whether the [Baseboard] is on the left or right side of the board.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];
    final direction = _side.direction;
    final arcsAngle = -1.11 * direction;
    const arcsRotation = math.pi / 2.08;

    final topCircleShape = CircleShape()..radius = 0.7;
    topCircleShape.position.setValues(11.39 * direction, 6.05);
    final topCircleFixtureDef = FixtureDef(topCircleShape);
    fixturesDef.add(topCircleFixtureDef);

    final innerEdgeShape = EdgeShape()
      ..set(
        Vector2(10.86 * direction, 6.45),
        Vector2(6.96 * direction, 0.25),
      );
    final innerEdgeShapeFixtureDef = FixtureDef(innerEdgeShape);
    fixturesDef.add(innerEdgeShapeFixtureDef);

    final outerEdgeShape = EdgeShape()
      ..set(
        Vector2(11.96 * direction, 5.85),
        Vector2(5.48 * direction, -4.85),
      );
    final outerEdgeShapeFixtureDef = FixtureDef(outerEdgeShape);
    fixturesDef.add(outerEdgeShapeFixtureDef);

    final upperArcShape = ArcShape(
      center: Vector2(1.76 * direction, 3.25),
      arcRadius: 6.1,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final upperArcFixtureDefs = FixtureDef(upperArcShape);
    fixturesDef.add(upperArcFixtureDefs);

    final lowerArcShape = ArcShape(
      center: Vector2(1.85 * direction, -2.15),
      arcRadius: 4.5,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final lowerArcFixtureDefs = FixtureDef(lowerArcShape);
    fixturesDef.add(lowerArcFixtureDefs);

    final bottomRectangle = PolygonShape()
      ..setAsBox(
        7,
        2,
        Vector2(-5.14 * direction, -4.75),
        0,
      );
    final bottomRectangleFixtureDef = FixtureDef(bottomRectangle);
    fixturesDef.add(bottomRectangleFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    // TODO(allisonryan0002): share sweeping angle with flipper when components
    // are grouped.
    const angle = math.pi / 5;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..angle = _side.isLeft ? -angle : angle;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
