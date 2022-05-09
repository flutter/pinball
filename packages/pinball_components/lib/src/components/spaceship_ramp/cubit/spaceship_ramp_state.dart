// ignore_for_file: comment_references

part of 'spaceship_ramp_cubit.dart';

class SpaceshipRampState extends Equatable {
  const SpaceshipRampState({
    required this.hits,
    required this.lightState,
  }) : assert(hits >= 0, "Hits can't be negative");

  const SpaceshipRampState.initial()
      : this(
          hits: 0,
          lightState: ArrowLightState.inactive,
        );

  final int hits;
  final ArrowLightState lightState;

  bool get arrowFullyLit => lightState == ArrowLightState.active5;

  SpaceshipRampState copyWith({
    int? hits,
    ArrowLightState? lightState,
  }) {
    return SpaceshipRampState(
      hits: hits ?? this.hits,
      lightState: lightState ?? this.lightState,
    );
  }

  @override
  List<Object?> get props => [hits, lightState];
}

/// Indicates the state of the arrow on the [SpaceshipRamp].
enum ArrowLightState {
  /// Arrow with no lights lit up.
  inactive,

  /// Arrow with 1 light lit up.
  active1,

  /// Arrow with 2 lights lit up.
  active2,

  /// Arrow with 3 lights lit up.
  active3,

  /// Arrow with 4 lights lit up.
  active4,

  /// Arrow with all 5 lights lit up.
  active5,
}
