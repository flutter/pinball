// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/spaceship_ramp/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/android_ramp_sensor_cubit.dart';

/// {@template android_ramp}
/// [AndroidRamp] with a for the [SpaceshipRamp].
/// {@endtemplate}
class AndroidRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro android_ramp}
  AndroidRamp()
      : super(
          children: [
            AndroidRampSensor(type: AndroidRampSensorType.door)
              ..initialPosition = Vector2(1.7, -20),
            AndroidRampSensor(type: AndroidRampSensorType.inside)
              ..initialPosition = Vector2(1.7, -21.5),
            AndroidRampBonusBehavior(
              shotPoints: 5000,
              bonusPoints: 1000000,
            ),
          ],
        );

  late final SpaceshipRamp spaceshipRamp = SpaceshipRamp();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addFromBlueprint(spaceshipRamp);
  }

  /// Creates a [AndroidRamp] without any children.
  ///
  /// This can be used for testing [AndroidRamp]'s behaviors in isolation.
  @visibleForTesting
  AndroidRamp.test();
}

/// {@template android_ramp_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SpaceshipRamp].
/// {@endtemplate}
@visibleForTesting
class AndroidRampSensor extends BodyComponent
    with ParentIsA<AndroidRamp>, InitialPosition {
  /// {@macro android_ramp_sensor}
  AndroidRampSensor({required this.type})
      : bloc = AndroidRampSensorCubit(),
        super(
          children: [
            RampShotBehavior(),
          ],
          renderBody: false,
        );

  /// Creates a [AndroidRampSensor] without any children.
  ///
  @visibleForTesting
  AndroidRampSensor.test({
    required this.type,
    required this.bloc,
  });

  /// Type for the sensor, to know if it's the one at the door or inside ramp.
  final AndroidRampSensorType type;

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final AndroidRampSensorCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

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
