// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template controlled_spaceship_ramp}
/// [SpaceshipRamp] with a [_SpaceshipRampController] attached.
/// {@endtemplate}
class ControlledSpaceshipRamp extends Component
    with Controls<_SpaceshipRampController>, HasGameRef<PinballGame> {
  /// {@macro controlled_spaceship_ramp}
  ControlledSpaceshipRamp() {
    controller = _SpaceshipRampController(this);
  }

  late final SpaceshipRamp _spaceshipRamp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(SpaceshipRampSensorBallContactCallback());

    _spaceshipRamp = SpaceshipRamp();
    final spaceshipRampSensor = SpaceshipRampSensor()
      ..initialPosition = Vector2(1.7, -20);

    await gameRef.addFromBlueprint(_spaceshipRamp);
    await add(spaceshipRampSensor);
  }
}

/// {@template spaceship_ramp_controller}
/// Controller attached to a [SpaceshipRamp] that handles its game related
/// logic.
/// {@endtemplate}

class _SpaceshipRampController
    extends ComponentController<ControlledSpaceshipRamp>
    with HasGameRef<PinballGame> {
  /// {@macro spaceship_ramp_controller}
  _SpaceshipRampController(ControlledSpaceshipRamp controlledSpaceshipRamp)
      : super(controlledSpaceshipRamp);

  final int _oneMillionPointsTarget = 10;
  final int _scoreMultiplierTarget = 6;

  int _hitsCounter = 0;

  void shot() {
    _hitsCounter++;

    component._spaceshipRamp.progress();

    // TODO(ruimiguel): increase score multiplier x1 .
    print('Multiplier x1');

    if (_hitsCounter % _scoreMultiplierTarget == 0) {
      // TODO(ruimiguel): reset score multiplier and multiply score x6 .
      print('Reset multiplier and multiply score x6');
    }
    if (_hitsCounter % _oneMillionPointsTarget == 0) {
      gameRef.read<GameBloc>().add(const Scored(points: 1000000));
    }
  }
}

/// {@template spaceship_ramp_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SpaceshipRamp] with the [SpaceshipRampSensorBallContactCallback].
/// {@endtemplate}
@visibleForTesting
class SpaceshipRampSensor extends BodyComponent with InitialPosition {
  /// {@macro spaceship_ramp_sensor}
  SpaceshipRampSensor() {
    renderBody = true;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        2,
        .1,
        initialPosition,
        -5 * math.pi / 180,
      );

    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template spaceship_ramp_sensor_ball_contact_callback}
/// Turbo charges the [Ball] on contact with [SparkyTurboChargeSensor].
/// {@endtemplate}
@visibleForTesting
class SpaceshipRampSensorBallContactCallback
    extends ContactCallback<SpaceshipRampSensor, ControlledBall> {
  /// {@macro spaceship_ramp_sensor_ball_contact_callback}
  SpaceshipRampSensorBallContactCallback();

  @override
  void begin(
    SpaceshipRampSensor spaceshipRampSensor,
    _,
    __,
  ) {
    final parent = spaceshipRampSensor.parent;
    if (parent is ControlledSpaceshipRamp) {
      parent.controller.shot();
    }
  }
}
