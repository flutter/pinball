// ignore_for_file: comment_references, avoid_renaming_method_parameters

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
  DinoWalls();

  @override
  void build(_) {
    addAll([
      _DinoTopWall(),
      _DinoBottomWall(),
    ]);
  }
}

/// {@template dino_top_wall}
/// Wall segment located above [ChromeDino].
/// {@endtemplate}
class _DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  _DinoTopWall() : super(priority: 1);

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(28.4, -35.1),
        Vector2(29.5, -35.1),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final topCurveShape = BezierCurveShape(
      controlPoints: [
        topStraightShape.vertex1,
        Vector2(17.4, -26.38),
        Vector2(25.5, -20.7),
      ],
    );
    fixturesDef.add(FixtureDef(topCurveShape));

    final middleCurveShape = BezierCurveShape(
      controlPoints: [
        topCurveShape.vertices.last,
        Vector2(27.8, -20.1),
        Vector2(26.8, -19.5),
      ],
    );
    fixturesDef.add(FixtureDef(middleCurveShape));

    final bottomCurveShape = BezierCurveShape(
      controlPoints: [
        middleCurveShape.vertices.last,
        Vector2(21.15, -16),
        Vector2(25.6, -15.2),
      ],
    );
    fixturesDef.add(FixtureDef(bottomCurveShape));

    final bottomStraightShape = EdgeShape()
      ..set(
        bottomCurveShape.vertices.last,
        Vector2(31, -14.5),
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
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
    renderBody = false;

    await add(_DinoTopWallSpriteComponent());
  }
}

class _DinoTopWallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.dino.dinoLandTop.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(22, -41.8);
  }
}

/// {@template dino_bottom_wall}
/// Wall segment located below [ChromeDino].
/// {@endtemplate}
class _DinoBottomWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  _DinoBottomWall();

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final topStraightControlPoints = [
      Vector2(32.4, -8.3),
      Vector2(25, -7.7),
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
      Vector2(21.8, -7),
      Vector2(29.5, 13.8),
    ];
    final topLeftCurveShape = BezierCurveShape(
      controlPoints: topLeftCurveControlPoints,
    );
    fixturesDef.add(FixtureDef(topLeftCurveShape));

    final bottomLeftStraightControlPoints = [
      topLeftCurveControlPoints.last,
      Vector2(31.8, 44.1),
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
      Vector2(37.8, 44.1),
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
    renderBody = false;

    await add(_DinoBottomWallSpriteComponent());
  }
}

class _DinoBottomWallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.dino.dinoLandBottom.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(23.8, -9.5);
  }
}
