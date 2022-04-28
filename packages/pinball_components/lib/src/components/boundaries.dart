import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template boundaries}
/// A [Blueprint] which creates the [_BottomBoundary] and [_OuterBoundary].
///{@endtemplate boundaries}
class Boundaries extends Blueprint {
  /// {@macro boundaries}
  Boundaries()
      : super(
          components: [
            _BottomBoundary(),
            _OuterBoundary(),
            _OuterBottomBoundarySpriteComponent(),
          ],
        );
}

/// {@template bottom_boundary}
/// Curved boundary at the bottom of the board where the [Ball] exits the field
/// of play.
/// {@endtemplate bottom_boundary}
class _BottomBoundary extends BodyComponent with InitialPosition {
  /// {@macro bottom_boundary}
  _BottomBoundary()
      : super(
          renderBody: false,
          priority: RenderPriority.bottomBoundary,
          children: [_BottomBoundarySpriteComponent()],
        );

  List<FixtureDef> _createFixtureDefs() {
    final bottomLeftCurve = BezierCurveShape(
      controlPoints: [
        Vector2(-43.9, 41.8),
        Vector2(-35.7, 43),
        Vector2(-19.9, 51),
      ],
    );
    final bottomLeftCurveFixtureDef = FixtureDef(bottomLeftCurve);

    final bottomRightCurve = BezierCurveShape(
      controlPoints: [
        Vector2(31.8, 44.8),
        Vector2(21.95, 47.7),
        Vector2(12.3, 52.1),
      ],
    );
    final bottomRightCurveFixtureDef = FixtureDef(bottomRightCurve);

    return [bottomLeftCurveFixtureDef, bottomRightCurveFixtureDef];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _BottomBoundarySpriteComponent extends SpriteComponent with HasGameRef {
  _BottomBoundarySpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-5, 55.6),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.boundary.bottom.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

/// {@template outer_boundary}
/// Boundary enclosing the top and left side of the board. The right side of the
/// board is closed by the barrier the [LaunchRamp] creates.
/// {@endtemplate outer_boundary}
class _OuterBoundary extends BodyComponent with InitialPosition {
  /// {@macro outer_boundary}
  _OuterBoundary()
      : super(
          renderBody: false,
          priority: RenderPriority.outerBoundary,
          children: [_OuterBoundarySpriteComponent()],
        );

  List<FixtureDef> _createFixtureDefs() {
    final topWall = EdgeShape()
      ..set(
        Vector2(3.6, -70.2),
        Vector2(-14.1, -70.2),
      );

    final topLeftCurve = BezierCurveShape(
      controlPoints: [
        topWall.vertex1,
        Vector2(-31.5, -69.9),
        Vector2(-32.3, -57.2),
      ],
    );

    final topLeftWall = EdgeShape()
      ..set(
        topLeftCurve.vertices.last,
        Vector2(-33.5, -44),
      );

    final upperLeftWallCurve = BezierCurveShape(
      controlPoints: [
        topLeftWall.vertex1,
        Vector2(-33.9, -40.7),
        Vector2(-32.5, -39),
      ],
    );

    final middleLeftWallCurve = BezierCurveShape(
      controlPoints: [
        upperLeftWallCurve.vertices.last,
        Vector2(-23.2, -31.4),
        Vector2(-33.9, -21.8),
      ],
    );

    final lowerLeftWallCurve = BezierCurveShape(
      controlPoints: [
        middleLeftWallCurve.vertices.last,
        Vector2(-32.4, -17.6),
        Vector2(-37.3, -11),
      ],
    );

    final bottomLeftWall = EdgeShape()
      ..set(
        lowerLeftWallCurve.vertices.last,
        Vector2(-43.9, 41.8),
      );

    return [
      FixtureDef(topWall),
      FixtureDef(topLeftCurve),
      FixtureDef(topLeftWall),
      FixtureDef(upperLeftWallCurve),
      FixtureDef(middleLeftWallCurve),
      FixtureDef(lowerLeftWallCurve),
      FixtureDef(bottomLeftWall),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _OuterBoundarySpriteComponent extends SpriteComponent with HasGameRef {
  _OuterBoundarySpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -7.8),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.boundary.outer.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _OuterBottomBoundarySpriteComponent extends SpriteComponent
    with HasGameRef {
  _OuterBottomBoundarySpriteComponent()
      : super(
          priority: RenderPriority.outerBottomBoundary,
          anchor: Anchor.center,
          position: Vector2(0, 71),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.boundary.outerBottom.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
