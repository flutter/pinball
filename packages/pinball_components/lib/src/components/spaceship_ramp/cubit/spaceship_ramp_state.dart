// ignore_for_file: public_member_api_docs

part of 'spaceship_ramp_cubit.dart';

/// Used to know when a [Ball] gets into the [SpaceshipRamp] against every ball
/// that crosses the opening.
enum RampSensorType {
  /// Sensor at the entrance of the opening.
  door,

  /// Sensor inside the [SpaceshipRamp].
  inside,
}

enum SpaceshipRampStatus {
  withoutBonus,
  withBonus,
}

class SpaceshipRampState extends Equatable {
  const SpaceshipRampState({
    required this.hits,
    required this.balls,
    required this.shot,
    required this.status,
  }) : assert(hits >= 0, "Hits can't be negative");

  SpaceshipRampState.initial()
      : this(
          hits: 0,
          balls: HashSet(),
          shot: false,
          status: SpaceshipRampStatus.withoutBonus,
        );

  final int hits;
  final Set<Ball> balls;
  final bool shot;
  final SpaceshipRampStatus status;

  SpaceshipRampState copyWith({
    int? hits,
    Set<Ball>? balls,
    bool? shot,
    SpaceshipRampStatus? status,
  }) {
    return SpaceshipRampState(
      hits: hits ?? this.hits,
      balls: balls ?? this.balls,
      shot: shot ?? this.shot,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [hits, balls, shot, status];
}
