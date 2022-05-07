// ignore_for_file: comment_references

part of 'spaceship_ramp_cubit.dart';

class SpaceshipRampState extends Equatable {
  const SpaceshipRampState({
    required this.hits,
    required this.lightState,
    required this.animationState,
  }) : assert(hits >= 0, "Hits can't be negative");

  const SpaceshipRampState.initial()
      : this(
          hits: 0,
          lightState: ArrowLightState.inactive,
          animationState: ArrowAnimationState.idle,
        );

  final int hits;
  final ArrowLightState lightState;
  final ArrowAnimationState animationState;

  SpaceshipRampState copyWith({
    int? hits,
    ArrowLightState? lightState,
    ArrowAnimationState? animationState,
  }) {
    return SpaceshipRampState(
      hits: hits ?? this.hits,
      lightState: lightState ?? this.lightState,
      animationState: animationState ?? this.animationState,
    );
  }

  @override
  List<Object?> get props => [hits, lightState, animationState];
}

/// Indicates the state of the arrow on the [SpaceshipRamp].
enum ArrowLightState {
  /// Arrow with no dashes lit up.
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

// Indicates if the blinking animation is running.
enum ArrowAnimationState {
  idle,
  blinking,
}
