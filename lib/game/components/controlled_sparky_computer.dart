// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template controlled_sparky_computer}
/// [SparkyComputer] with a [SparkyComputerController] attached.
/// {@endtemplate}
class ControlledSparkyComputer extends SparkyComputer
    with Controls<SparkyComputerController>, HasGameRef<Forge2DGame> {
  /// {@macro controlled_sparky_computer}
  ControlledSparkyComputer() : super() {
    controller = SparkyComputerController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(SparkyComputerSensorBallContactCallback());
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

/// {@template sparky_computer_sensor_ball_contact_callback}
/// Turbo charges the [Ball] when it enters the [SparkyComputer]
/// {@endtemplate}
@visibleForTesting
class SparkyComputerSensorBallContactCallback
    extends ContactCallback<SparkyComputerSensor, ControlledBall> {
  /// {@macro sparky_computer_sensor_ball_contact_callback}
  SparkyComputerSensorBallContactCallback();

  @override
  void begin(_, ControlledBall ball, __) {
    ball.controller.turboCharge();
  }
}
