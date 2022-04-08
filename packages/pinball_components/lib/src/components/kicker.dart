import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:geometry/geometry.dart' as geometry show centroid;
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template kicker}
/// Triangular [BodyType.static] body that propels the [Ball] towards the
/// opposite side.
///
/// [Kicker]s are usually positioned above each [Flipper].
/// {@endtemplate kicker}
class Kicker extends BodyComponent with InitialPosition {
  /// {@macro kicker}
  Kicker({
    required BoardSide side,
  }) : _side = side;

  /// The size of the [Kicker] body.
  static final Vector2 size = Vector2(4.4, 15);

  /// Whether the [Kicker] is on the left or right side of the board.
  ///
  /// A [Kicker] with [BoardSide.left] propels the [Ball] to the right,
  /// whereas a [Kicker] with [BoardSide.right] propels the [Ball] to the
  /// left.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];
    final direction = _side.direction;
    const quarterPi = math.pi / 4;

    final upperCircle = CircleShape()..radius = 1.6;
    upperCircle.position.setValues(0, -upperCircle.radius / 2);
    final upperCircleFixtureDef = FixtureDef(upperCircle)..friction = 0;
    fixturesDefs.add(upperCircleFixtureDef);

    final lowerCircle = CircleShape()..radius = 1.6;
    lowerCircle.position.setValues(
      size.x * -direction,
      -size.y - 0.8,
    );
    final lowerCircleFixtureDef = FixtureDef(lowerCircle)..friction = 0;
    fixturesDefs.add(lowerCircleFixtureDef);

    final wallFacingEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * direction,
              0,
            ),
        Vector2(2.5 * direction, -size.y + 2),
      );
    final wallFacingLineFixtureDef = FixtureDef(wallFacingEdge)..friction = 0;
    fixturesDefs.add(wallFacingLineFixtureDef);

    final bottomEdge = EdgeShape()
      ..set(
        wallFacingEdge.vertex2,
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * direction,
              -lowerCircle.radius * math.sin(quarterPi),
            ),
      );
    final bottomLineFixtureDef = FixtureDef(bottomEdge)..friction = 0;
    fixturesDefs.add(bottomLineFixtureDef);

    final bouncyEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * math.cos(quarterPi) * -direction,
              upperCircle.radius * math.sin(quarterPi),
            ),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              lowerCircle.radius * math.sin(quarterPi),
            ),
      );

    final bouncyFixtureDef = FixtureDef(bouncyEdge)
      // TODO(alestiago): Play with restitution value once game is bundled.
      ..restitution = 10.0
      ..friction = 0;
    fixturesDefs.add(bouncyFixtureDef);

    // TODO(alestiago): Evaluate if there is value on centering the fixtures.
    final centroid = geometry.centroid(
      [
        upperCircle.position + Vector2(0, -upperCircle.radius),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              -lowerCircle.radius * math.sin(quarterPi),
            ),
        wallFacingEdge.vertex2,
      ],
    );
    for (final fixtureDef in fixturesDefs) {
      fixtureDef.shape.moveBy(-centroid);
    }

    return fixturesDefs;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    await add(_KickerSpriteComponent(side: _side));
  }
}

class _KickerSpriteComponent extends SpriteComponent with HasGameRef {
  _KickerSpriteComponent({required BoardSide side}) : _side = side;

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      (_side.isLeft)
          ? Assets.images.kicker.left.keyName
          : Assets.images.kicker.right.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(0.7 * -_side.direction, -2.2);
  }
}

// TODO(alestiago): Evaluate if there's value on generalising this to
// all shapes.
extension on Shape {
  void moveBy(Vector2 offset) {
    if (this is CircleShape) {
      final circle = this as CircleShape;
      circle.position.setFrom(circle.position + offset);
    } else if (this is EdgeShape) {
      final edge = this as EdgeShape;
      edge.set(edge.vertex1 + offset, edge.vertex2 + offset);
    }
  }
}
