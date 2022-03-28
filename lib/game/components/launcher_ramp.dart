// ignore_for_file: public_member_api_docs, avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Blueprint] which creates the [LauncherRamp].
class Launcher extends Forge2DBlueprint {
  @override
  void build(_) {
    final position = Vector2(
      PinballGame.boardBounds.right - 31.3,
      PinballGame.boardBounds.bottom + 33,
    );

    addAllContactCallback([
      RampOpeningBallContactCallback<_LauncherRampOpening>(),
    ]);

    final leftOpening = _LauncherRampOpening(rotation: math.pi / 2)
      ..initialPosition = position + Vector2(-11.8, 72.7)
      ..layer = Layer.opening;
    final rightOpening = _LauncherRampOpening(rotation: 0)
      ..initialPosition = position + Vector2(-5.4, 65.4)
      ..layer = Layer.opening;

    final launcherRamp = LauncherRamp()
      ..initialPosition = position + Vector2(1.7, 0)
      ..layer = Layer.launcher;

    addAll([
      leftOpening,
      rightOpening,
      launcherRamp,
    ]);
  }
}

/// {@template launcher_ramp}
/// The yellow right ramp, where the [Ball] goes through when launched from the
/// [Plunger].
/// {@endtemplate}
class LauncherRamp extends BodyComponent with InitialPosition, Layered {
  /// {@macro launcher_ramp}
  LauncherRamp() : super(priority: 2) {
    layer = Layer.launcher;
    paint = Paint()
      ..color = const Color.fromARGB(255, 251, 255, 0)
      ..style = PaintingStyle.stroke;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  /// Radius of the external arc at the top of the ramp.
  static const _externalRadius = 16.3;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final startPosition = initialPosition + Vector2(0, 3);
    final endPosition = initialPosition + Vector2(0, 130);

    final rightStraightShape = EdgeShape()
      ..set(
        startPosition..rotate(PinballGame.boardPerspectiveAngle),
        endPosition..rotate(PinballGame.boardPerspectiveAngle),
      );
    final rightStraightFixtureDef = FixtureDef(rightStraightShape);
    fixturesDef.add(rightStraightFixtureDef);

    final leftStraightShape = EdgeShape()
      ..set(
        startPosition - Vector2(width, 0),
        endPosition - Vector2(width, 0),
      );
    final leftStraightFixtureDef = FixtureDef(leftStraightShape);
    fixturesDef.add(leftStraightFixtureDef);

    final externalCurveShape = ArcShape(
      center: initialPosition + Vector2(-28.2, 132),
      arcRadius: _externalRadius,
      angle: math.pi / 2,
      rotation: 3 * math.pi / 2,
    );
    final externalCurveFixtureDef = FixtureDef(externalCurveShape);
    fixturesDef.add(externalCurveFixtureDef);

    final internalCurveShape = externalCurveShape.copyWith(
      arcRadius: _externalRadius - width,
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
/// inside [LauncherRamp].
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

  static final Vector2 _size = Vector2(LauncherRamp.width / 3, .1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
