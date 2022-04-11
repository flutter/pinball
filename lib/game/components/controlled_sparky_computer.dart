// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template controlled_sparky_computer}
/// [SparkyComputer] with a [SparkyComputerController] attached.
/// {@endtemplate}
class ControlledSparkyComputer extends SparkyComputer
    with Controls<SparkyComputerController>, HasGameRef<PinballGame> {
  /// {@macro controlled_sparky_computer}
  ControlledSparkyComputer() {
    controller = SparkyComputerController(this);
  }

  @override
  void build(Forge2DGame _) {
    addContactCallback(SparkyTurboChargeSensorBallContactCallback());
    final sparkyTurboChargeSensor = SparkyTurboChargeSensor()
      ..initialPosition = Vector2(-13, 49.8);
    add(sparkyTurboChargeSensor);
    super.build(_);
  }
}

/// {@template sparky_computer_controller}
/// Controller attached to a [SparkyComputer] that handles its game related
/// logic.
/// {@endtemplate}
// TODO(allisonryan0002): listen for turbo charge game bonus and animate Sparky.
class SparkyComputerController
    extends ComponentController<ControlledSparkyComputer> {
  /// {@macro sparky_computer_controller}
  SparkyComputerController(ControlledSparkyComputer controlledComputer)
      : super(controlledComputer);
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

    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

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
    ball.controller.turboCharge();
  }
}
