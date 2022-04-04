// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template boundaries}
/// A [Blueprint] which creates the [_BottomBoundary] and [_OuterBoundary].
///{@endtemplate boundaries}
class Boundaries extends Forge2DBlueprint {
  @override
  void build(_) {
    final bottomBoundary = _BottomBoundary();
    final outerBoundary = _OuterBoundary();

    addAll([bottomBoundary, outerBoundary]);
  }
}

/// {@template bottom_boundary}
/// Curved boundary at the bottom of the board where the [Ball] exits the field
/// of play.
/// {@endtemplate bottom_boundary}
class _BottomBoundary extends BodyComponent with InitialPosition {
  /// {@macro bottom_boundary}
  _BottomBoundary() : super(priority: 2);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];

    final bottomLeftCurve = BezierCurveShape(
      controlPoints: [
        Vector2(-43.6, -44.4),
        Vector2(-31, -43.4),
        Vector2(-18.7, -52.1),
      ],
    );
    final bottomLeftCurveFixtureDef = FixtureDef(bottomLeftCurve);
    fixturesDefs.add(bottomLeftCurveFixtureDef);

    final bottomRightCurve = BezierCurveShape(
      controlPoints: [
        Vector2(31.8, -44.1),
        Vector2(21.95, -47),
        Vector2(12.3, -51.4),
      ],
    );
    final bottomRightCurveFixtureDef = FixtureDef(bottomRightCurve);
    fixturesDefs.add(bottomRightCurveFixtureDef);

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
    await _loadSprite();
    renderBody = false;
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.boundary.bottom.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        position: Vector2(-5.4, 57.4),
      ),
    );
  }
}

/// {@template outer_boundary}
/// Boundary enclosing the top and left side of the board. The right side of the
/// board is closed by the barrier the [LaunchRamp] creates.
/// {@endtemplate outer_boundary}
class _OuterBoundary extends BodyComponent with InitialPosition {
  /// {@macro outer_boundary}
  _OuterBoundary() : super(priority: -1);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDefs = <FixtureDef>[];

    final topWall = EdgeShape()
      ..set(
        Vector2(3.6, 70.2),
        Vector2(-14.1, 70.2),
      );
    final topWallFixtureDef = FixtureDef(topWall);
    fixturesDefs.add(topWallFixtureDef);

    final topLeftCurve = BezierCurveShape(
      controlPoints: [
        Vector2(-32.3, 57.2),
        Vector2(-31.5, 69.9),
        Vector2(-14.1, 70.2),
      ],
    );
    final topLeftCurveFixtureDef = FixtureDef(topLeftCurve);
    fixturesDefs.add(topLeftCurveFixtureDef);

    final leftWall = EdgeShape()
      ..set(
        Vector2(-32.3, 57.2),
        Vector2(-44.1, -44.4),
      );
    final leftWallFixtureDef = FixtureDef(leftWall);
    fixturesDefs.add(leftWallFixtureDef);

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
    await _loadSprite();
    renderBody = false;
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.boundary.outer.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        position: Vector2(-0.2, -1.4),
      ),
    );
  }
}
