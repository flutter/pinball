// ignore_for_file: public_member_api_docs, avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Blueprint] which creates the launcher ramp.
class Launcher extends Forge2DBlueprint {
  /// Width between walls of the [Pathway].
  static const width = 5.0;

  /// Size for the radius of the external wall [Pathway].
  static const externalRadius = 16.3;

  @override
  void build(_) {
    final position = Vector2(
      PinballGame.boardBounds.right - 30,
      PinballGame.boardBounds.bottom + 40,
    );

    addAllContactCallback([
      RampOpeningBallContactCallback<_LauncherRampOpening>(),
    ]);

    final straightPath = LauncherStraightRamp()
      ..initialPosition = position + Vector2(1.7, 0)
      ..layer = Layer.launcher;

    final curvedPath = LauncherCurveRamp()
      ..initialPosition = position + Vector2(-12, 59.3)
      ..layer = Layer.launcher;

    final leftOpening = _LauncherRampOpening(rotation: math.pi / 2)
      ..initialPosition = position + Vector2(-11.6, 66.3)
      ..layer = Layer.opening;
    final rightOpening = _LauncherRampOpening(rotation: 0)
      ..initialPosition = position + Vector2(-4.9, 59.4)
      ..layer = Layer.opening;

    addAll([
      straightPath,
      curvedPath,
      leftOpening,
      rightOpening,
    ]);
  }
}

/// {@template launcher_straight_ramp}
/// The green left ramp, where the [Ball] goes through when launched from the
/// [Plunger].
/// {@endtemplate}
class LauncherStraightRamp extends BodyComponent with InitialPosition, Layered {
  /// {@macro launcher_straight_ramp}
  LauncherStraightRamp() : super(priority: 2) {
    layer = Layer.launcher;
    paint = Paint()
      ..color = const Color.fromARGB(255, 34, 255, 0)
      ..style = PaintingStyle.stroke;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final launcherRampRotation =
        -math.atan(18.6 / PinballGame.boardBounds.height);

    final startPosition = initialPosition + Vector2(0, 3);
    final endPosition = initialPosition + Vector2(0, 117);

    final externalStraightShape = EdgeShape()
      ..set(
        startPosition..rotate(launcherRampRotation),
        endPosition..rotate(launcherRampRotation),
      );
    final externalStraightFixtureDef = FixtureDef(externalStraightShape);
    fixturesDef.add(externalStraightFixtureDef);

    final internalStraightShape = EdgeShape()
      ..set(
        startPosition - Vector2(Launcher.width, 0),
        endPosition - Vector2(Launcher.width, 0),
      );
    final internalStraightFixtureDef = FixtureDef(internalStraightShape);
    fixturesDef.add(internalStraightFixtureDef);

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

/// {@template launcher_curve_ramp}
/// The yellow left ramp, where the [Ball] goes through when launched from the
/// [Plunger].
/// {@endtemplate}
class LauncherCurveRamp extends BodyComponent with InitialPosition, Layered {
  /// {@macro launcher_curve_ramp}
  LauncherCurveRamp() : super(priority: 2) {
    layer = Layer.launcher;
    paint = Paint()
      ..color = const Color.fromARGB(255, 251, 255, 0)
      ..style = PaintingStyle.stroke;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final externalCurveShape = ArcShape(
      center: initialPosition,
      arcRadius: Launcher.externalRadius,
      angle: math.pi / 2,
      rotation: 3 * math.pi / 2,
    );
    final externalCurveFixtureDef = FixtureDef(externalCurveShape);
    fixturesDef.add(externalCurveFixtureDef);

    final internalCurveShape = externalCurveShape.copyWith(
      arcRadius: Launcher.externalRadius - Launcher.width,
    );
    final internalCurveFixtureDef = FixtureDef(internalCurveShape);
    fixturesDef.add(internalCurveFixtureDef);

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

/// {@template launcher_ramp_opening}
/// [RampOpening] with [Layer.launcher] to filter [Ball]s collisions
/// inside launcher ramp.
/// {@endtemplate}
class _LauncherRampOpening extends RampOpening {
  /// {@macro launcher_ramp_opening}
  _LauncherRampOpening({
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.launcher,
          orientation: RampOrientation.down,
        );

  final double _rotation;

  static final Vector2 _size = Vector2(Launcher.width / 3, .1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
