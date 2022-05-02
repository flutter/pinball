import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template spaceship_rail}
/// Rail exiting the [AndroidSpaceship].
/// {@endtemplate}
class SpaceshipRail extends Component {
  /// {@macro spaceship_rail}
  SpaceshipRail()
      : super(
          children: [
            _SpaceshipRail(),
            _SpaceshipRailExit(),
            _SpaceshipRailExitSpriteComponent()
          ],
        );
}

class _SpaceshipRail extends BodyComponent with Layered, ZIndex {
  _SpaceshipRail()
      : super(
          children: [_SpaceshipRailSpriteComponent()],
          renderBody: false,
        ) {
    layer = Layer.spaceshipExitRail;
    zIndex = ZIndexes.spaceshipRail;
  }

  List<FixtureDef> _createFixtureDefs() {
    final topArcShape = ArcShape(
      center: Vector2(-35.1, -30.9),
      arcRadius: 2.5,
      angle: math.pi,
      rotation: 0.2,
    );

    final topLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-37.6, -30.4),
        Vector2(-37.8, -23.9),
        Vector2(-30.93, -18.2),
      ],
    );

    final middleLeftCurveShape = BezierCurveShape(
      controlPoints: [
        topLeftCurveShape.vertices.last,
        Vector2(-22.6, -10.3),
        Vector2(-29.5, -0.2),
      ],
    );

    final bottomLeftCurveShape = BezierCurveShape(
      controlPoints: [
        middleLeftCurveShape.vertices.last,
        Vector2(-35.6, 8.6),
        Vector2(-31.3, 18.3),
      ],
    );

    final topRightStraightShape = EdgeShape()
      ..set(
        Vector2(-27.2, -21.3),
        Vector2(-33, -31.3),
      );

    final middleRightCurveShape = BezierCurveShape(
      controlPoints: [
        topRightStraightShape.vertex1,
        Vector2(-16.5, -11.4),
        Vector2(-25.29, 1.7),
      ],
    );

    final bottomRightCurveShape = BezierCurveShape(
      controlPoints: [
        middleRightCurveShape.vertices.last,
        Vector2(-29.91, 8.5),
        Vector2(-26.8, 15.7),
      ],
    );

    return [
      FixtureDef(topArcShape),
      FixtureDef(topLeftCurveShape),
      FixtureDef(middleLeftCurveShape),
      FixtureDef(bottomLeftCurveShape),
      FixtureDef(topRightStraightShape),
      FixtureDef(middleRightCurveShape),
      FixtureDef(bottomRightCurveShape),
    ];
  }

  @override
  Body createBody() {
    final body = world.createBody(BodyDef());
    _createFixtureDefs().forEach(body.createFixture);
    return body;
  }
}

class _SpaceshipRailSpriteComponent extends SpriteComponent with HasGameRef {
  _SpaceshipRailSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-29.4, -5.7),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.rail.main.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _SpaceshipRailExitSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _SpaceshipRailExitSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-28, 19.4),
        ) {
    zIndex = ZIndexes.spaceshipRailExit;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.rail.exit.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _SpaceshipRailExit extends LayerSensor {
  _SpaceshipRailExit()
      : super(
          orientation: LayerEntranceOrientation.down,
          insideLayer: Layer.spaceshipExitRail,
          insideZIndex: ZIndexes.ballOnSpaceshipRail,
        ) {
    layer = Layer.spaceshipExitRail;
  }

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(-29, 19),
      arcRadius: 2.5,
      angle: math.pi * 0.4,
      rotation: -1.4,
    );
  }
}
