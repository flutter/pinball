import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template slingshots}
/// A [Blueprint] which creates the pair of [Slingshot]s on the right side of
/// the board.
/// {@endtemplate}
class Slingshots extends Blueprint {
  /// {@macro slingshots}
  Slingshots()
      : super(
          components: [
            Slingshot(
              length: 5.64,
              angle: -0.017,
              spritePath: Assets.images.slingshot.upper.keyName,
            )..initialPosition = Vector2(22.3, -1.58),
            Slingshot(
              length: 3.46,
              angle: -0.468,
              spritePath: Assets.images.slingshot.lower.keyName,
            )..initialPosition = Vector2(24.7, 6.2),
          ],
        );
}

/// {@template slingshot}
/// Elastic bumper that bounces the [Ball] off of its straight sides.
/// {@endtemplate}
class Slingshot extends BodyComponent with InitialPosition {
  /// {@macro slingshot}
  Slingshot({
    required double length,
    required double angle,
    required String spritePath,
  })  : _length = length,
        _angle = angle,
        super(
          priority: RenderPriority.slingshot,
          children: [_SlinghsotSpriteComponent(spritePath, angle: angle)],
        ) {
    renderBody = false;
  }

  final double _length;

  final double _angle;

  List<FixtureDef> _createFixtureDefs() {
    const circleRadius = 1.55;

    final topCircleShape = CircleShape()..radius = circleRadius;
    topCircleShape.position.setValues(0, -_length / 2);
    final topCircleFixtureDef = FixtureDef(topCircleShape);

    final bottomCircleShape = CircleShape()..radius = circleRadius;
    bottomCircleShape.position.setValues(0, _length / 2);
    final bottomCircleFixtureDef = FixtureDef(bottomCircleShape);

    final leftEdgeShape = EdgeShape()
      ..set(
        Vector2(circleRadius, _length / 2),
        Vector2(circleRadius, -_length / 2),
      );
    final leftEdgeShapeFixtureDef = FixtureDef(
      leftEdgeShape,
      restitution: 5,
    );

    final rightEdgeShape = EdgeShape()
      ..set(
        Vector2(-circleRadius, _length / 2),
        Vector2(-circleRadius, -_length / 2),
      );
    final rightEdgeShapeFixtureDef = FixtureDef(
      rightEdgeShape,
      restitution: 5,
    );

    return [
      topCircleFixtureDef,
      bottomCircleFixtureDef,
      leftEdgeShapeFixtureDef,
      rightEdgeShapeFixtureDef,
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
      angle: _angle,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _SlinghsotSpriteComponent extends SpriteComponent with HasGameRef {
  _SlinghsotSpriteComponent(
    String path, {
    required double angle,
  })  : _path = path,
        super(
          angle: -angle,
          anchor: Anchor.center,
        );

  final String _path;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(gameRef.images.fromCache(_path));
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
