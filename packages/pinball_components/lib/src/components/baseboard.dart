import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template baseboard}
/// Wing-shaped board piece to corral the [Ball] towards the [Flipper]s.
/// {@endtemplate}
class Baseboard extends BodyComponent with InitialPosition {
  /// {@macro baseboard}
  Baseboard({
    required BoardSide side,
  })  : _side = side,
        super(
          renderBody: false,
          children: [_BaseboardSpriteComponent(side: side)],
        );

  /// Whether the [Baseboard] is on the left or right side of the board.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final direction = _side.direction;
    const arcsAngle = 1.11;
    final arcsRotation = (_side.isLeft) ? -2.7 : -1.6;

    final pegBumperShape = CircleShape()..radius = 0.7;
    pegBumperShape.position.setValues(11.11 * direction, -7.15);
    final pegBumperFixtureDef = FixtureDef(pegBumperShape);

    final topCircleShape = CircleShape()..radius = 0.7;
    topCircleShape.position.setValues(9.71 * direction, -4.95);
    final topCircleFixtureDef = FixtureDef(topCircleShape);

    final innerEdgeShape = EdgeShape()
      ..set(
        Vector2(9.01 * direction, -5.35),
        Vector2(5.29 * direction, 0.95),
      );
    final innerEdgeShapeFixtureDef = FixtureDef(innerEdgeShape);

    final outerEdgeShape = EdgeShape()
      ..set(
        Vector2(10.41 * direction, -4.75),
        Vector2(3.79 * direction, 5.95),
      );
    final outerEdgeShapeFixtureDef = FixtureDef(outerEdgeShape);

    final upperArcShape = ArcShape(
      center: Vector2(0.09 * direction, -2.15),
      arcRadius: 6.1,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final upperArcFixtureDef = FixtureDef(upperArcShape);

    final lowerArcShape = ArcShape(
      center: Vector2(0.09 * direction, 3.35),
      arcRadius: 4.5,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final lowerArcFixtureDef = FixtureDef(lowerArcShape);

    final bottomRectangle = PolygonShape()
      ..setAsBox(
        6.8,
        2,
        Vector2(-6.3 * direction, 5.85),
        0,
      );
    final bottomRectangleFixtureDef = FixtureDef(bottomRectangle);

    return [
      pegBumperFixtureDef,
      topCircleFixtureDef,
      innerEdgeShapeFixtureDef,
      outerEdgeShapeFixtureDef,
      upperArcFixtureDef,
      lowerArcFixtureDef,
      bottomRectangleFixtureDef,
    ];
  }

  @override
  Body createBody() {
    const angle = 37.1 * (math.pi / 180);
    final bodyDef = BodyDef(
      position: initialPosition,
      angle: -angle * _side.direction,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _BaseboardSpriteComponent extends SpriteComponent with HasGameRef {
  _BaseboardSpriteComponent({required BoardSide side})
      : _side = side,
        super(
          anchor: Anchor.center,
          position: Vector2(0.4 * -side.direction, 0),
        );

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        (_side.isLeft)
            ? Assets.images.baseboard.left.keyName
            : Assets.images.baseboard.right.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
