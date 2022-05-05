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
class _DinoTopWall extends BodyComponent with InitialPosition {
  ///{@macro dino_top_wall}
  _DinoTopWall()
      : super(
          children: [
            _DinoTopWallSpriteComponent(),
            _DinoTopWallTunnelSpriteComponent(),
          ],
          renderBody: false,
        );

  List<FixtureDef> _createFixtureDefs() {
    final topEdgeShape = EdgeShape()
      ..set(
        Vector2(29.05, -35.27),
        Vector2(28.2, -34.77),
      );

    final topCurveShape = BezierCurveShape(
      controlPoints: [
        topEdgeShape.vertex2,
        Vector2(21.15, -28.72),
        Vector2(23.25, -24.62),
      ],
    );

    final tunnelTopEdgeShape = EdgeShape()
      ..set(
        topCurveShape.vertices.last,
        Vector2(30.15, -27.32),
      );

    final tunnelBottomEdgeShape = EdgeShape()
      ..set(
        Vector2(30.55, -23.17),
        Vector2(25.25, -21.22),
      );

    final middleEdgeShape = EdgeShape()
      ..set(
        tunnelBottomEdgeShape.vertex2,
        Vector2(27.25, -19.32),
      );

    final bottomEdgeShape = EdgeShape()
      ..set(
        middleEdgeShape.vertex2,
        Vector2(24.45, -15.02),
      );

    final undersideEdgeShape = EdgeShape()
      ..set(
        bottomEdgeShape.vertex2,
        Vector2(31.55, -13.77),
      );

    return [
      FixtureDef(topEdgeShape),
      FixtureDef(topCurveShape),
      FixtureDef(tunnelTopEdgeShape),
      FixtureDef(tunnelBottomEdgeShape),
      FixtureDef(middleEdgeShape),
      FixtureDef(bottomEdgeShape),
      FixtureDef(undersideEdgeShape),
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

class _DinoTopWallSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _DinoTopWallSpriteComponent()
      : super(
          position: Vector2(22.55, -38.07),
        ) {
    zIndex = ZIndexes.dinoTopWall;
  }

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
  }
}

class _DinoTopWallTunnelSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _DinoTopWallTunnelSpriteComponent()
      : super(position: Vector2(23.11, -26.01)) {
    zIndex = ZIndexes.dinoTopWallTunnel;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.dino.topWallTunnel.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
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
    final topEdgeShape = EdgeShape()
      ..set(
        Vector2(32.2, -8.8),
        Vector2(24.8, -7.7),
      );

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        topEdgeShape.vertex2,
        Vector2(21.6, -7),
        Vector2(29.6, 13.8),
      ],
    );

    final bottomLeftEdgeShape = EdgeShape()
      ..set(
        topLeftCurveShape.vertices.last,
        Vector2(31.7, 44.1),
      );

    final bottomEdgeShape = EdgeShape()
      ..set(
        bottomLeftEdgeShape.vertex2,
        Vector2(37.6, 44.1),
      );

    return [
      FixtureDef(topEdgeShape),
      FixtureDef(topLeftCurveShape),
      FixtureDef(bottomLeftEdgeShape),
      FixtureDef(bottomEdgeShape),
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
    position = Vector2(23.6, -9.5);
  }
}
