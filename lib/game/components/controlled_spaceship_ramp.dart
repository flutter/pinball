// ignore_for_file: avoid_renaming_method_parameters

import 'dart:collection';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template controlled_spaceship_ramp}
/// [SpaceshipRamp] with a [SpaceshipRampController] attached.
/// {@endtemplate}
class ControlledSpaceshipRamp extends Component
    with Controls<SpaceshipRampController>, HasGameRef<PinballGame> {
  /// {@macro controlled_spaceship_ramp}
  ControlledSpaceshipRamp() {
    controller = SpaceshipRampController(this);
  }

  late final SpaceshipRamp _spaceshipRamp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(SpaceshipRampSensorBallContactCallback());

    _spaceshipRamp = SpaceshipRamp();
    await addFromBlueprint(_spaceshipRamp);
    await addAll([
      SpaceshipRampSensor(type: SpaceshipRampSensorType.door)
        ..initialPosition = Vector2(1.7, -20),
      SpaceshipRampSensor(type: SpaceshipRampSensorType.inside)
        ..initialPosition = Vector2(1.7, -21.5),
    ]);
  }
}

/// {@template spaceship_ramp_controller}
/// Controller attached to a [SpaceshipRamp] that handles its game related
/// logic.
/// {@endtemplate}

class SpaceshipRampController
    extends ComponentController<ControlledSpaceshipRamp>
    with HasGameRef<PinballGame> {
  /// {@macro spaceship_ramp_controller}
  SpaceshipRampController(ControlledSpaceshipRamp controlledSpaceshipRamp)
      : super(controlledSpaceshipRamp);

  final int _oneMillionPointsTarget = 10;

  int _hitsCounter = 0;

  /// When a [Ball] shot the [SpaceshipRamp] it achieve improvements for the
  /// current game, like multipliers or score.
  void shot() {
    _hitsCounter++;

    component._spaceshipRamp.progress();

    gameRef.read<GameBloc>().add(const Scored(points: 5000));

    // TODO(ruimiguel): increase here multiplier at GameBloc.

    if (_hitsCounter % _oneMillionPointsTarget == 0) {
      // TODO(ruimiguel): One million by bonus??
      const oneMillion = 1000000;
      gameRef.read<GameBloc>().add(const Scored(points: oneMillion));
      gameRef.add(
        ScoreText(
          text: oneMillion.toString(),
          position: Vector2(1.7, -20),
        ),
      );
    }
  }
}

/// Used to know when a [Ball] gets into the [SpaceshipRamp] against every ball
/// that crosses the opening.
@visibleForTesting
enum SpaceshipRampSensorType {
  /// Sensor at the entrance of the opening.
  door,

  /// Sensor inside the [SpaceshipRamp].
  inside,
}

/// {@template spaceship_ramp_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SpaceshipRamp].
/// {@endtemplate}
@visibleForTesting
class SpaceshipRampSensor extends BodyComponent with InitialPosition, Layered {
  /// {@macro spaceship_ramp_sensor}
  SpaceshipRampSensor({required this.type}) : super() {
    layer = Layer.spaceshipEntranceRamp;
    renderBody = false;
  }

  /// Type for the sensor, to know if it's the one at the door or inside ramp.
  final SpaceshipRampSensorType type;

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        2,
        2,
        initialPosition,
        -5 * math.pi / 180,
      );

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

/// {@template spaceship_ramp_sensor_ball_contact_callback}
/// Turbo charges the [Ball] on contact with [SpaceshipRampSensor].
/// {@endtemplate}
@visibleForTesting
class SpaceshipRampSensorBallContactCallback
    extends ContactCallback<SpaceshipRampSensor, ControlledBall> {
  /// {@macro spaceship_ramp_sensor_ball_contact_callback}
  SpaceshipRampSensorBallContactCallback();

  final Set<Ball> _balls = HashSet();

  @override
  void begin(
    SpaceshipRampSensor spaceshipRampSensor,
    ControlledBall ball,
    __,
  ) {
    switch (spaceshipRampSensor.type) {
      case SpaceshipRampSensorType.door:
        if (!_balls.contains(ball)) {
          _balls.add(ball);
        }
        break;
      case SpaceshipRampSensorType.inside:
        if (_balls.contains(ball)) {
          final parent = spaceshipRampSensor.parent;
          if (parent is ControlledSpaceshipRamp) {
            parent.controller.shot();
          }
          _balls.remove(ball);
        }
        break;
    }
  }
}
