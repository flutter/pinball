// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template launch_ramp}
/// A [Blueprint] which creates the [_LaunchRampBase] and
/// [_LaunchRampForegroundRailing].
/// {@endtemplate}
class LaunchRamp extends Forge2DBlueprint {
  @override
  void build(_) {
    addAllContactCallback([
      LayerSensorBallContactCallback<_LaunchRampExit>(),
    ]);

    final launchRampBase = _LaunchRampBase();

    final launchRampForegroundRailing = _LaunchRampForegroundRailing();

    final launchRampExit = _LaunchRampExit(rotation: math.pi / 2)
      ..initialPosition = Vector2(0.6, -34);

    final launchRampCloseWall = _LaunchRampCloseWall()
      ..initialPosition = Vector2(4, -69.5);

    addAll([
      launchRampBase,
      launchRampForegroundRailing,
      launchRampExit,
      launchRampCloseWall,
    ]);
  }
}

/// {@template launch_ramp_base}
/// Ramp the [Ball] is launched from at the beginning of each ball life.
/// {@endtemplate}
class _LaunchRampBase extends BodyComponent with InitialPosition, Layered {
  /// {@macro launch_ramp_base}
  _LaunchRampBase()
      : super(
          priority: Ball.launchRampPriority - 1,
          children: [
            _LaunchRampBackgroundRailingSpriteComponent(),
            _LaunchRampBaseSpriteComponent(),
          ],
        ) {
    layer = Layer.launcher;
    renderBody = false;
  }

  // TODO(ruimiguel): final asset differs slightly from the current shape. We
  // need to fix shape with correct vertices, but right now merge them to have
  // final assets at game and not be blocked.
  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(31.4, -61.4),
        Vector2(46.5, 68.4),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final leftStraightShape = EdgeShape()
      ..set(
        Vector2(27.8, -61.4),
        Vector2(41.5, 68.4),
      );
    final leftStraightFixtureDef = FixtureDef(leftStraightShape);
    fixturesDef.add(leftStraightFixtureDef);

    final topCurveShape = ArcShape(
      center: Vector2(20.5, -61.1),
      arcRadius: 11,
      angle: 1.6,
      rotation: 0.1,
    );
    final topCurveFixtureDef = FixtureDef(topCurveShape);
    fixturesDef.add(topCurveFixtureDef);

    final bottomCurveShape = ArcShape(
      center: Vector2(19.3, -60.3),
      arcRadius: 8.5,
      angle: 1.48,
      rotation: 0.1,
    );
    final bottomCurveFixtureDef = FixtureDef(bottomCurveShape);
    fixturesDef.add(bottomCurveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, -70.1),
        Vector2(19.1, -72.1),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final bottomStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, -66.9),
        Vector2(19.1, -68.8),
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

    return fixturesDef;
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

class _LaunchRampBaseSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.launchRamp.ramp.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(25.65, 0.7);
  }
}

class _LaunchRampBackgroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.launchRamp.backgroundRailing.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(25.6, -1.3);
  }
}

/// {@template launch_ramp_foreground_railing}
/// Foreground railing for the [_LaunchRampBase] to render in front of the
/// [Ball].
/// {@endtemplate}
class _LaunchRampForegroundRailing extends BodyComponent with InitialPosition {
  /// {@macro launch_ramp_foreground_railing}
  _LaunchRampForegroundRailing()
      : super(
          priority: Ball.launchRampPriority + 1,
          children: [_LaunchRampForegroundRailingSpriteComponent()],
        ) {
    renderBody = false;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(27.6, -57.9),
        Vector2(38.1, 42.6),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final curveShape = ArcShape(
      center: Vector2(20.1, -59.3),
      arcRadius: 7.5,
      angle: 1.8,
      rotation: -0.13,
    );
    final curveFixtureDef = FixtureDef(curveShape);
    fixturesDef.add(curveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, -66.8),
        Vector2(19.7, -66.8),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _LaunchRampForegroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.launchRamp.foregroundRailing.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(22.8, 0.5);
  }
}

class _LaunchRampCloseWall extends BodyComponent with InitialPosition, Layered {
  _LaunchRampCloseWall() {
    layer = Layer.board;
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = EdgeShape()..set(Vector2.zero(), Vector2(0, 3));

    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template launch_ramp_exit}
/// [LayerSensor] with [Layer.launcher] to filter [Ball]s exiting the
/// [LaunchRamp].
/// {@endtemplate}
class _LaunchRampExit extends LayerSensor {
  /// {@macro launch_ramp_exit}
  _LaunchRampExit({
    required double rotation,
  })  : _rotation = rotation,
        super(
          insideLayer: Layer.launcher,
          outsideLayer: Layer.board,
          orientation: LayerEntranceOrientation.down,
          insidePriority: Ball.launchRampPriority,
          outsidePriority: 0,
        ) {
    layer = Layer.launcher;
    renderBody = false;
  }

  final double _rotation;

  static final Vector2 _size = Vector2(1.6, 0.1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
