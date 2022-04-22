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
class SparkyFireZone extends Blueprint {
  /// {@macro sparky_fire_zone}
  SparkyFireZone()
      : super(
          components: [
            _SparkyBumper.a()..initialPosition = Vector2(-22.9, -41.65),
            _SparkyBumper.b()..initialPosition = Vector2(-21.25, -57.9),
            _SparkyBumper.c()..initialPosition = Vector2(-3.3, -52.55),
            SparkyComputerSensor()..initialPosition = Vector2(-13, -49.8),
            SparkyAnimatronic()..position = Vector2(-13.8, -58.2),
          ],
          blueprints: [
            SparkyComputer(),
          ],
        );
}

// TODO(alestiago): Revisit ScorePoints logic once the FlameForge2D
// ContactCallback process is enhanced.
class _SparkyBumper extends SparkyBumper with ScorePoints {
  _SparkyBumper.a() : super.a();

  _SparkyBumper.b() : super.b();

  _SparkyBumper.c() : super.c();

  @override
  int get points => 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alestiago): Revisit once this has been merged:
    // https://github.com/flame-engine/flame/pull/1547
    gameRef.addContactCallback(SparkyBumperBallContactCallback());
  }
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

/// {@template sparky_computer_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SparkyComputer].
/// {@endtemplate}
// TODO(alestiago): Revisit once this has been merged:
// https://github.com/flame-engine/flame/pull/1547
class SparkyComputerSensor extends BodyComponent with InitialPosition {
  /// {@macro sparky_computer_sensor}
  SparkyComputerSensor() {
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.1;
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alestiago): Revisit once this has been merged:
    // https://github.com/flame-engine/flame/pull/1547
    gameRef.addContactCallback(SparkyComputerSensorBallContactCallback());
  }
}

@visibleForTesting
// TODO(alestiago): Revisit once this has been merged:
// https://github.com/flame-engine/flame/pull/1547
// ignore: public_member_api_docs
class SparkyComputerSensorBallContactCallback
    extends ContactCallback<SparkyComputerSensor, ControlledBall> {
  @override
  void begin(_, ControlledBall controlledBall, __) {
    controlledBall.controller.turboCharge();
    controlledBall.gameRef.firstChild<SparkyAnimatronic>()?.playing = true;
  }
}
