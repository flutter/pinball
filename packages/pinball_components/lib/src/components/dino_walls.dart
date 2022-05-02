import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template dino_walls}
/// Walls near the [ChromeDino].
/// {@endtemplate}
class DinoWalls extends Component {
  /// {@macro dino_walls}
  DinoWalls()
      : super(
          children: [
            _DinoTopWall(),
            _DinoBottomWall(),
          ],
        );
}

/// {@template dino_top_wall}
/// Wall segment located above [ChromeDino].
/// {@endtemplate}
class _DinoTopWall extends BodyComponent with InitialPosition, ZIndex {
  ///{@macro dino_top_wall}
  _DinoTopWall()
      : super(
          children: [_DinoTopWallSpriteComponent()],
          renderBody: false,
        ) {
    zIndex = ZIndexes.dinoTopWall;
  }

  List<FixtureDef> _createFixtureDefs() {
    final topStraightShape = EdgeShape()
      ..set(
        Vector2(28.65, -34.3),
        Vector2(29.5, -34.3),
      );

    final topCurveShape = BezierCurveShape(
      controlPoints: [
        topStraightShape.vertex1,
        Vector2(18.8, -26.2),
        Vector2(26.6, -20.2),
      ],
    );

    final middleCurveShape = BezierCurveShape(
      controlPoints: [
        topCurveShape.vertices.last,
        Vector2(27.8, -19.3),
        Vector2(26.8, -18.7),
      ],
    );

    final bottomCurveShape = BezierCurveShape(
      controlPoints: [
        middleCurveShape.vertices.last,
        Vector2(23, -14.2),
        Vector2(27, -14.2),
      ],
    );

    final bottomStraightShape = EdgeShape()
      ..set(
        bottomCurveShape.vertices.last,
        Vector2(31, -13.7),
      );

    return [
      FixtureDef(topStraightShape),
      FixtureDef(topCurveShape),
      FixtureDef(middleCurveShape),
      FixtureDef(bottomCurveShape),
      FixtureDef(bottomStraightShape),
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

class _DinoTopWallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.dino.topWall.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(22.8, -38.1);
  }
}

/// {@template dino_bottom_wall}
/// Wall segment located below [ChromeDino].
/// {@endtemplate}
class _DinoBottomWall extends BodyComponent with InitialPosition, ZIndex {
  ///{@macro dino_top_wall}
  _DinoBottomWall()
      : super(
          children: [_DinoBottomWallSpriteComponent()],
          renderBody: false,
        ) {
    zIndex = ZIndexes.dinoBottomWall;
  }

  List<FixtureDef> _createFixtureDefs() {
    final topStraightShape = EdgeShape()
      ..set(
        Vector2(32.4, -8.8),
        Vector2(25, -7.7),
      );

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        topStraightShape.vertex2,
        Vector2(21.8, -7),
        Vector2(29.8, 13.8),
      ],
    );

    final bottomLeftStraightShape = EdgeShape()
      ..set(
        topLeftCurveShape.vertices.last,
        Vector2(31.9, 44.1),
      );

    final bottomStraightShape = EdgeShape()
      ..set(
        bottomLeftStraightShape.vertex2,
        Vector2(37.8, 44.1),
      );

    return [
      FixtureDef(topStraightShape),
      FixtureDef(topLeftCurveShape),
      FixtureDef(bottomLeftStraightShape),
      FixtureDef(bottomStraightShape),
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
        Assets.images.dino.bottomWall.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    position = Vector2(23.8, -9.5);
  }
}
