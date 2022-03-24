// ignore_for_file: public_member_api_docs, avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Blueprint] which creates the [JetpackRamp].
class Jetpack extends Forge2DBlueprint {
  /// Width between walls of the [Pathway].
  static const width = 5.0;

  /// Size for the radius of the external wall [Pathway].
  static const externalRadius = 18.0;

  @override
  void build(_) {
    final position = Vector2(
      PinballGame.boardBounds.left + 40.5,
      PinballGame.boardBounds.top - 31.5,
    );

    addAllContactCallback([
      RampOpeningBallContactCallback<_JetpackRampOpening>(),
    ]);

    final _leftOpening = _JetpackRampOpening(
      outsideLayer: Layer.spaceship,
      rotation: math.pi,
    )
      ..initialPosition = position + Vector2(-2.5, -20.2)
      ..layer = Layer.jetpack;

    final _curve = JetpackRamp()
      ..initialPosition = position + Vector2(5, -20.2)
      ..layer = Layer.jetpack;
    final _rightOpening = _JetpackRampOpening(
      rotation: math.pi,
    )
      ..initialPosition = position + Vector2(12.9, -20.2)
      ..layer = Layer.opening;

    addAll([
      _leftOpening,
      _curve,
      _rightOpening,
    ]);
  }
}

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp of the [Board].
/// {@endtemplate}
class JetpackRamp extends BodyComponent with InitialPosition, Layered {
  JetpackRamp() : super(priority: 2) {
    layer = Layer.jetpack;
    paint = Paint()
      ..color = const Color.fromARGB(255, 8, 218, 241)
      ..style = PaintingStyle.stroke;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final externalCurveShape = ArcShape(
      center: initialPosition,
      arcRadius: Jetpack.externalRadius,
      angle: math.pi,
      rotation: math.pi,
    );
    final externalFixtureDef = FixtureDef(externalCurveShape);
    fixturesDef.add(externalFixtureDef);

    final internalCurveShape = externalCurveShape.copyWith(
      arcRadius: Jetpack.externalRadius - Jetpack.width,
    );
    final internalFixtureDef = FixtureDef(internalCurveShape);
    fixturesDef.add(internalFixtureDef);

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

/// {@template jetpack_ramp_opening}
/// [RampOpening] with [Layer.jetpack] to filter [Ball] collisions
/// inside [JetpackRamp].
/// {@endtemplate}
class _JetpackRampOpening extends RampOpening {
  /// {@macro jetpack_ramp_opening}
  _JetpackRampOpening({
    Layer? outsideLayer,
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.jetpack,
          outsideLayer: outsideLayer,
          orientation: RampOrientation.down,
        );

  final double _rotation;

  static final Vector2 _size = Vector2(Jetpack.width / 3, .1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
