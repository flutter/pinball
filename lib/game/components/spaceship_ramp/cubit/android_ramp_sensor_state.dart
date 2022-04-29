part of 'android_ramp_sensor_cubit.dart';

/// Used to know when a [Ball] gets into the [SpaceshipRamp] against every ball
/// that crosses the opening.
enum AndroidRampSensorType {
  /// Sensor at the entrance of the opening.
  door,

  /// Sensor inside the [SpaceshipRamp].
  inside,
}

class AndroidRampSensorState extends Equatable {
  const AndroidRampSensorState({
    required this.type,
    this.ball,
  });

  /// {@macro assets_manager_state}
  const AndroidRampSensorState.initial()
      : this(type: AndroidRampSensorType.door);

  final AndroidRampSensorType type;
  final Ball? ball;

  AndroidRampSensorState copyWith({
    AndroidRampSensorType? type,
    Ball? ball,
  }) {
    return AndroidRampSensorState(
      type: type ?? this.type,
      ball: ball ?? this.ball,
    );
  }

  @override
  List<Object?> get props => [type, ball];
}
