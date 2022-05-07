// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template launch_ramp}
/// Ramp where the ball is launched from.
/// {@endtemplate}
class LaunchRamp extends Component {
  /// {@macro launch_ramp}
  LaunchRamp()
      : super(
          children: [
            _LaunchRampBase(),
            _LaunchRampForegroundRailing(),
          ],
        );
}

class _LaunchRampBase extends BodyComponent with Layered, ZIndex {
  _LaunchRampBase()
      : super(
          renderBody: false,
          children: [
            _LaunchRampBackgroundRailingSpriteComponent(),
            _LaunchRampBaseSpriteComponent(),
          ],
        ) {
    zIndex = ZIndexes.launchRamp;
    layer = Layer.launcher;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(31, -61.4),
        Vector2(46.1, 68.4),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final leftStraightShape = EdgeShape()
      ..set(
        Vector2(27.4, -61.4),
        Vector2(41.1, 68.4),
      );
    final leftStraightFixtureDef = FixtureDef(leftStraightShape);
    fixturesDef.add(leftStraightFixtureDef);

    final topCurveShape = ArcShape(
      center: Vector2(20.1, -61.1),
      arcRadius: 11,
      angle: 1.6,
      rotation: 0.1,
    );
    final topCurveFixtureDef = FixtureDef(topCurveShape);
    fixturesDef.add(topCurveFixtureDef);

    final bottomCurveShape = ArcShape(
      center: Vector2(18.9, -60.3),
      arcRadius: 8.5,
      angle: 1.48,
      rotation: 0.1,
    );
    final bottomCurveFixtureDef = FixtureDef(bottomCurveShape);
    fixturesDef.add(bottomCurveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.3, -70.1),
        Vector2(18.7, -72.1),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final bottomStraightShape = EdgeShape()
      ..set(
        Vector2(3.3, -66.9),
        Vector2(18.7, -68.8),
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final body = world.createBody(BodyDef());
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _LaunchRampBaseSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.launchRamp.ramp.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(25.25, 0.7);
  }
}

class _LaunchRampBackgroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.launchRamp.backgroundRailing.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(25.2, -1.3);
  }
}

class _LaunchRampForegroundRailing extends BodyComponent with ZIndex {
  _LaunchRampForegroundRailing()
      : super(
          children: [_LaunchRampForegroundRailingSpriteComponent()],
          renderBody: false,
        ) {
    zIndex = ZIndexes.launchRampForegroundRailing;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(27.2, -57.9),
        Vector2(37.7, 42.6),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final curveShape = ArcShape(
      center: Vector2(19.7, -59.3),
      arcRadius: 7.5,
      angle: 1.8,
      rotation: -0.13,
    );
    final curveFixtureDef = FixtureDef(curveShape);
    fixturesDef.add(curveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.3, -66.8),
        Vector2(19.3, -66.8),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final body = world.createBody(BodyDef());
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _LaunchRampForegroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.launchRamp.foregroundRailing.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(22.4, 0.5);
  }
}
