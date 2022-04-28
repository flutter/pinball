import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template dinowalls}
/// A [Blueprint] which creates walls for the [ChromeDino].
/// {@endtemplate}
class DinoWalls extends Blueprint {
  /// {@macro dinowalls}
  DinoWalls()
      : super(
          components: [
            _DinoTopWall(),
            _DinoBottomWall(),
          ],
        );
}

/// {@template dino_top_wall}
/// Wall segment located above [ChromeDino].
/// {@endtemplate}
class _DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  _DinoTopWall()
      : super(
          priority: RenderPriority.dinoTopWall,
          children: [_DinoTopWallSpriteComponent()],
          renderBody: false,
        );

  List<FixtureDef> _createFixtureDefs() {
    final topStraightShape = EdgeShape()
      ..set(
        Vector2(28.65, -35.1),
        Vector2(29.5, -35.1),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);

    final topCurveShape = BezierCurveShape(
      controlPoints: [
        topStraightShape.vertex1,
        Vector2(18.8, -27),
        Vector2(26.6, -21),
      ],
    );
    final topCurveFixtureDef = FixtureDef(topCurveShape);

    final middleCurveShape = BezierCurveShape(
      controlPoints: [
        topCurveShape.vertices.last,
        Vector2(27.8, -20.1),
        Vector2(26.8, -19.5),
      ],
    );
    final middleCurveFixtureDef = FixtureDef(middleCurveShape);

    final bottomCurveShape = BezierCurveShape(
      controlPoints: [
        middleCurveShape.vertices.last,
        Vector2(23, -15),
        Vector2(27, -15),
      ],
    );
    final bottomCurveFixtureDef = FixtureDef(bottomCurveShape);

    final bottomStraightShape = EdgeShape()
      ..set(
        bottomCurveShape.vertices.last,
        Vector2(31, -14.5),
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);

    return [
      topStraightFixtureDef,
      topCurveFixtureDef,
      middleCurveFixtureDef,
      bottomCurveFixtureDef,
      bottomStraightFixtureDef,
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

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
}

class _DinoTopWallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.dino.dinoLandTop.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(22.8, -38.9);
  }
}

/// {@template dino_bottom_wall}
/// Wall segment located below [ChromeDino].
/// {@endtemplate}
class _DinoBottomWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  _DinoBottomWall()
      : super(
          priority: RenderPriority.dinoBottomWall,
          children: [_DinoBottomWallSpriteComponent()],
          renderBody: false,
        );

  List<FixtureDef> _createFixtureDefs() {
    const restitution = 1.0;

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(32.4, -8.8),
        Vector2(25, -7.7),
      );
    final topStraightFixtureDef = FixtureDef(
      topStraightShape,
      restitution: restitution,
    );

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        topStraightShape.vertex2,
        Vector2(21.8, -7),
        Vector2(29.8, 13.8),
      ],
    );
    final topLeftCurveFixtureDef = FixtureDef(
      topLeftCurveShape,
      restitution: restitution,
    );

    final bottomLeftStraightShape = EdgeShape()
      ..set(
        topLeftCurveShape.vertices.last,
        Vector2(31.9, 44.1),
      );
    final bottomLeftStraightFixtureDef = FixtureDef(
      bottomLeftStraightShape,
      restitution: restitution,
    );

    final bottomStraightShape = EdgeShape()
      ..set(
        bottomLeftStraightShape.vertex2,
        Vector2(37.8, 44.1),
      );
    final bottomStraightFixtureDef = FixtureDef(
      bottomStraightShape,
      restitution: restitution,
    );

    return [
      topStraightFixtureDef,
      topLeftCurveFixtureDef,
      bottomLeftStraightFixtureDef,
      bottomStraightFixtureDef,
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _DinoBottomWallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.dino.dinoLandBottom.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(23.6, -9.5);
  }
}
