// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_fire_zone}
/// Area positioned at the top left of the [Board] where the [Ball]
/// can bounce off [SparkyBumper]s.
///
/// When a [Ball] hits [SparkyBumper]s, the bumper animates.
/// {@endtemplate}
class SparkyFireZone extends Forge2DBlueprint {
  @override
  void build(Forge2DGame gameRef) {
    addBlueprint(SparkyComputer());

    gameRef.addContactCallback(SparkyBumperBallContactCallback());
    final sparkyTurboChargeSensor = SparkyTurboChargeSensor()
      ..initialPosition = Vector2(-13, 49.8);

    final sparkyAnimatronic = SparkyAnimatronic()
      ..position = Vector2(-13.8, -58.2);

    final lowerLeftBumper = _SparkyBumper.a()
      ..initialPosition = Vector2(-22.9, -41.65);
    final upperLeftBumper = _SparkyBumper.b()
      ..initialPosition = Vector2(-21.25, -57.9);
    final rightBumper = _SparkyBumper.c()
      ..initialPosition = Vector2(-3.3, -52.55);

    addAll([
      lowerLeftBumper,
      upperLeftBumper,
      rightBumper,
      sparkyAnimatronic,
      sparkyTurboChargeSensor,
    ]);
  }
}

// TODO(alestiago): Revisit ScorePoints logic once the FlameForge2D
// ContactCallback process is enhanced.
class _SparkyBumper extends SparkyBumper with ScorePoints {
  _SparkyBumper.a() : super.a();

  _SparkyBumper.b() : super.b();

  _SparkyBumper.c() : super.c();

  @override
  int get points => 20;
}

/// Listens when a [Ball] bounces bounces against a [SparkyBumper].
@visibleForTesting
class SparkyBumperBallContactCallback
    extends ContactCallback<SparkyBumper, Ball> {
  @override
  void begin(
    SparkyBumper sparkyBumper,
    Ball _,
    Contact __,
  ) {
    sparkyBumper.animate();
  }
}

/// {@template sparky_turbo_charge_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SparkyComputer] with the [SparkyTurboChargeSensorBallContactCallback].
/// {@endtemplate}
@visibleForTesting
class SparkyTurboChargeSensor extends BodyComponent with InitialPosition {
  /// {@macro sparky_turbo_charge_sensor}
  SparkyTurboChargeSensor() {
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.1;
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template sparky_turbo_charge_sensor_ball_contact_callback}
/// Turbo charges the [Ball] on contact with [SparkyTurboChargeSensor].
/// {@endtemplate}
@visibleForTesting
class SparkyTurboChargeSensorBallContactCallback
    extends ContactCallback<SparkyTurboChargeSensor, ControlledBall> {
  /// {@macro sparky_turbo_charge_sensor_ball_contact_callback}
  SparkyTurboChargeSensorBallContactCallback();

  @override
  void begin(
    SparkyTurboChargeSensor sparkyTurboChargeSensor,
    ControlledBall ball,
    _,
  ) {
    final parent = sparkyTurboChargeSensor.parent;
    if (parent is SparkyFireZone) {
      ball.controller.turboCharge();
    }
  }
}
