// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template launch_ramp}
/// A [Blueprint] which creates the [_LaunchRampBase] and
/// [_LaunchRampForegroundRailing].
/// {@endtemplate}
class LaunchRamp extends Forge2DBlueprint {
  @override
  void build(_) {
    addAllContactCallback([
      RampOpeningBallContactCallback<_LaunchRampExit>(),
    ]);

    final launchRampBase = _LaunchRampBase()..layer = Layer.launcher;

    final launchRampForegroundRailing = _LaunchRampForegroundRailing()
      ..layer = Layer.launcher;

    final launchRampExit = _LaunchRampExit(rotation: math.pi / 2)
      ..initialPosition = Vector2(1.8, 34.2)
      ..layer = Layer.opening
      ..renderBody = false;

    addAll([
      launchRampBase,
      launchRampForegroundRailing,
      launchRampExit,
    ]);
  }
}

/// {@template launch_ramp_base}
/// Ramp the [Ball] is launched from at the beginning of each ball life.
/// {@endtemplate}
class _LaunchRampBase extends BodyComponent with InitialPosition, Layered {
  /// {@macro launch_ramp_base}
  _LaunchRampBase() : super(priority: -1) {
    layer = Layer.launcher;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(31.4, 61.4),
        Vector2(46.5, -68.4),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final leftStraightShape = EdgeShape()
      ..set(
        Vector2(27.8, 61.4),
        Vector2(41.5, -68.4),
      );
    final leftStraightFixtureDef = FixtureDef(leftStraightShape);
    fixturesDef.add(leftStraightFixtureDef);

    final topCurveShape = ArcShape(
      center: Vector2(20.5, 61.1),
      arcRadius: 11,
      angle: 1.6,
      rotation: -1.65,
    );
    final topCurveFixtureDef = FixtureDef(topCurveShape);
    fixturesDef.add(topCurveFixtureDef);

    final bottomCurveShape = ArcShape(
      center: Vector2(19.3, 60.3),
      arcRadius: 8.5,
      angle: 1.48,
      rotation: -1.58,
    );
    final bottomCurveFixtureDef = FixtureDef(bottomCurveShape);
    fixturesDef.add(bottomCurveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 70.1),
        Vector2(19.1, 72.1),
      );
    final topStraightFixtureDef = FixtureDef(topStraightShape);
    fixturesDef.add(topStraightFixtureDef);

    final bottomStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 66.9),
        Vector2(19.1, 68.8),
      );
    final bottomStraightFixtureDef = FixtureDef(bottomStraightShape);
    fixturesDef.add(bottomStraightFixtureDef);

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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
    renderBody = false;
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.launchRamp.ramp.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        position: Vector2(25.65, 0),
      ),
    );
  }
}

/// {@template launch_ramp_foreground_railing}
/// Foreground railing for the [_LaunchRampBase] to render in front of the
/// [Ball].
/// {@endtemplate}
class _LaunchRampForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  /// {@macro launch_ramp_foreground_railing}
  _LaunchRampForegroundRailing() : super(priority: 1) {
    layer = Layer.launcher;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final rightStraightShape = EdgeShape()
      ..set(
        Vector2(27.6, 57.9),
        Vector2(30, 35.1),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final curveShape = ArcShape(
      center: Vector2(20.1, 59.3),
      arcRadius: 7.5,
      angle: 1.8,
      rotation: -1.63,
    );
    final curveFixtureDef = FixtureDef(curveShape);
    fixturesDef.add(curveFixtureDef);

    final topStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 66.8),
        Vector2(19.7, 66.8),
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
    renderBody = false;
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.launchRamp.foregroundRailing.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        position: Vector2(22.8, 0),
      ),
    );
  }
}

/// {@template launch_ramp_exit}
/// [RampOpening] with [Layer.launcher] to filter [Ball]s exiting the
/// [LaunchRamp].
/// {@endtemplate}
class _LaunchRampExit extends RampOpening {
  /// {@macro launch_ramp_exit}
  _LaunchRampExit({
    required double rotation,
  })  : _rotation = rotation,
        super(
          insideLayer: Layer.launcher,
          orientation: RampOrientation.down,
          insidePriority: 3,
        );

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
