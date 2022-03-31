// ignore_for_file: comment_references

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template dinowalls}
/// A [Blueprint] which creates walls for the [ChromeDino].
/// {@endtemplate}
class DinoWalls extends Forge2DBlueprint {
  /// {@macro dinowalls}
  DinoWalls({required this.position});

  /// Total size of the spaceship.
  static final size = Vector2(25, 19);

  /// The [position] where the elements will be created
  final Vector2 position;

  @override
  void build(_) {
    addAll([
      DinoTopWall()..initialPosition = position,
      DinoBottomWall()..initialPosition = position,
    ]);
  }
}

/// {@template dino_top_wall}
/// Wall segment located above [ChromeDino].
/// {@endtemplate}
class DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  DinoTopWall() : super(priority: 2);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final topStraightControlPoints = [
      Vector2(29.5, 35.1),
      Vector2(28.4, 35.1),
    ];
    final topStraightShape = EdgeShape()
      ..set(
        topStraightControlPoints.first,
        topStraightControlPoints.last,
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final topCurveControlPoints = [
      topStraightControlPoints.last,
      Vector2(17.4, 26.38),
      Vector2(25.5, 20.7),
    ];
    final topCurveShape = BezierCurveShape(
      controlPoints: topCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(topCurveShape));

    final middleCurveControlPoints = [
      topCurveControlPoints.last,
      Vector2(27.8, 20.1),
      Vector2(26.8, 19.5),
    ];
    final middleCurveShape = BezierCurveShape(
      controlPoints: middleCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(middleCurveShape));

    final bottomCurveControlPoints = [
      middleCurveControlPoints.last,
      Vector2(21.15, 16),
      Vector2(25.6, 15.2),
    ];
    final bottomCurveShape = BezierCurveShape(
      controlPoints: bottomCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(bottomCurveShape));

    final bottomStraightControlPoints = [
      bottomCurveControlPoints.last,
      Vector2(31, 14.5),
    ];
    final bottomStraightShape = EdgeShape()
      ..set(
        bottomStraightControlPoints.first,
        bottomStraightControlPoints.last,
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(
      (fixture) => body.createFixture(
        fixture
          ..restitution = 0.1
          ..friction = 0,
      ),
    );

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.dino.dinoLandTop.keyName,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(10.6, 27.7),
      anchor: Anchor.center,
      position: Vector2(27, -28.2),
    );

    await add(spriteComponent);
  }
}

/// {@template dino_bottom_wall}
/// Wall segment located below [ChromeDino].
/// {@endtemplate}
class DinoBottomWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  DinoBottomWall() : super(priority: 2);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final topStraightControlPoints = [
      Vector2(32.4, 8.3),
      Vector2(25, 7.7),
    ];
    final topStraightShape = EdgeShape()
      ..set(
        topStraightControlPoints.first,
        topStraightControlPoints.last,
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final topLeftCurveControlPoints = [
      topStraightControlPoints.last,
      Vector2(21.8, 7),
      Vector2(29.5, -13.8),
    ];
    final topLeftCurveShape = BezierCurveShape(
      controlPoints: topLeftCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(topLeftCurveShape));

    final bottomLeftStraightControlPoints = [
      topLeftCurveControlPoints.last,
      Vector2(31.8, -44.1),
    ];
    final bottomLeftStraightShape = EdgeShape()
      ..set(
        bottomLeftStraightControlPoints.first,
        bottomLeftStraightControlPoints.last,
      );
    final bottomLeftStraightFixtureDef = FixtureDef(bottomLeftStraightShape);
    fixturesDef.add(bottomLeftStraightFixtureDef);

    final bottomStraightControlPoints = [
      bottomLeftStraightControlPoints.last,
      Vector2(37.8, -44.1),
    ];
    final bottomStraightShape = EdgeShape()
      ..set(
        bottomStraightControlPoints.first,
        bottomStraightControlPoints.last,
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(
      (fixture) => body.createFixture(
        fixture
          ..restitution = 0.1
          ..friction = 0,
      ),
    );

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.dino.dinoLandBottom.keyName,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(15.6, 54.8),
      anchor: Anchor.center,
    )..position = Vector2(31.7, 18);

    await add(spriteComponent);
  }
}
