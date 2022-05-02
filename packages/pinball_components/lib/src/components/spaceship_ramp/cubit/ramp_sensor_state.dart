// ignore_for_file: public_member_api_docs

part of 'ramp_sensor_cubit.dart';

/// Used to know when a [Ball] gets into the [SpaceshipRamp] against every ball
/// that crosses the opening.
enum RampSensorType {
  /// Sensor at the entrance of the opening.
  door,

  /// Sensor inside the [SpaceshipRamp].
  inside,
}

class RampSensorState {
  const RampSensorState({
    required this.type,
    this.ball,
  });

  const RampSensorState.initial() : this(type: RampSensorType.door);

  final RampSensorType type;
  final Ball? ball;

  RampSensorState copyWith({
    RampSensorType? type,
    Ball? ball,
  }) {
    return RampSensorState(
      type: type ?? this.type,
      ball: ball ?? this.ball,
    );
  }
}
