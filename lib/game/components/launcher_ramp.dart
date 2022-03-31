// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template launcher}
/// A [Blueprint] which creates the [LauncherRamp] and
/// [LauncherForegroundRailing].
/// {@endtemplate}
class Launcher extends Forge2DBlueprint {
  @override
  void build(_) {
    addAllContactCallback([
      RampOpeningBallContactCallback<_LauncherExit>(),
    ]);

    final launcherRamp = LauncherRamp()..layer = Layer.launcher;

    final launcherForegroundRailing = LauncherForegroundRailing()
      ..layer = Layer.launcher;

    final launcherExit = _LauncherExit(rotation: math.pi / 2)
      ..initialPosition = Vector2(1.8, 34.2)
      ..layer = Layer.opening
      ..renderBody = false;

    addAll([
      launcherRamp,
      launcherForegroundRailing,
      launcherExit,
    ]);
  }
}

/// {@template launcher_ramp}
/// Ramp the [Ball] is launched from at the beginning of each ball life.
/// {@endtemplate}
class LauncherRamp extends BodyComponent with InitialPosition, Layered {
  /// {@macro launcher_ramp}
  LauncherRamp() : super(priority: -1) {
    layer = Layer.launcher;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final elevatedRightStraightShape = EdgeShape()
      ..set(
        Vector2(31.4, 61.4),
        Vector2(46.5, -68.4),
      );
    final elevatedRightStraightFixtureDef =
        FixtureDef(elevatedRightStraightShape);
    fixturesDef.add(elevatedRightStraightFixtureDef);

    final elevatedLeftStraightShape = EdgeShape()
      ..set(
        Vector2(27.8, 61.4),
        Vector2(41.5, -68.4),
      );
    final elevatedLeftStraightFixtureDef =
        FixtureDef(elevatedLeftStraightShape);
    fixturesDef.add(elevatedLeftStraightFixtureDef);

    final elevatedTopCurveShape = ArcShape(
      center: Vector2(20.5, 61.1),
      arcRadius: 11,
      angle: 1.6,
      rotation: -1.65,
    );
    final elevatedTopCurveFixtureDef = FixtureDef(elevatedTopCurveShape);
    fixturesDef.add(elevatedTopCurveFixtureDef);

    final elevatedTopStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 70.1),
        Vector2(19.1, 72.1),
      );
    final elevatedTopStraightFixtureDef = FixtureDef(elevatedTopStraightShape);
    fixturesDef.add(elevatedTopStraightFixtureDef);

    final elevatedBottomCurveShape = ArcShape(
      center: Vector2(19.3, 60.3),
      arcRadius: 8.5,
      angle: 1.48,
      rotation: -1.58,
    );
    final elevatedBottomCurveFixtureDef = FixtureDef(elevatedBottomCurveShape);
    fixturesDef.add(elevatedBottomCurveFixtureDef);

    final elevatedBottomStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 66.9),
        Vector2(19.1, 68.8),
      );
    final elevatedBottomStraightFixtureDef =
        FixtureDef(elevatedBottomStraightShape);
    fixturesDef.add(elevatedBottomStraightFixtureDef);

    return fixturesDef;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.components.launchRamp.launchRamp.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(44.7, 144.1),
      anchor: Anchor.center,
      position: Vector2(25.65, 0),
    );

    await gameRef.add(spriteComponent);

    renderBody = false;
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

/// {@template launcher_foreground_railing}
/// Foreground railing for the [LauncherRamp] to render in front of the [Ball].
/// {@endtemplate}
class LauncherForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  /// {@macro launcher_foreground_railing}
  LauncherForegroundRailing() : super(priority: 4) {
    layer = Layer.launcher;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final groundRightStraightShape = EdgeShape()
      ..set(
        Vector2(27.6, 57.9),
        Vector2(30, 35.1),
      );
    final groundRightStraightFixtureDef = FixtureDef(groundRightStraightShape);
    fixturesDef.add(groundRightStraightFixtureDef);

    final groundTopStraightShape = EdgeShape()
      ..set(
        Vector2(3.7, 66.8),
        Vector2(19.7, 66.8),
      );
    final groundTopStraightFixtureDef = FixtureDef(groundTopStraightShape);
    fixturesDef.add(groundTopStraightFixtureDef);

    final groundCurveShape = ArcShape(
      center: Vector2(20.1, 59.3),
      arcRadius: 7.5,
      angle: 1.8,
      rotation: -1.63,
    );
    final groundCurveFixtureDef = FixtureDef(groundCurveShape);
    fixturesDef.add(groundCurveFixtureDef);

    return fixturesDef;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.components.launchRamp.launchRailFG.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(38.1, 138.6),
      anchor: Anchor.center,
      position: Vector2(22.8, 0),
      priority: 4,
    );

    await gameRef.add(spriteComponent);

    renderBody = false;
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

/// {@template launcher_exit}
/// [RampOpening] with [Layer.launcher] to filter [Ball]s exiting the
/// [Launcher].
/// {@endtemplate}
class _LauncherExit extends RampOpening {
  /// {@macro launcher_exit}
  _LauncherExit({
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.launcher,
          orientation: RampOrientation.down,
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
