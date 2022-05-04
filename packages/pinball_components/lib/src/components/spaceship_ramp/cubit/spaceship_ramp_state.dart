// ignore_for_file: public_member_api_docs

part of 'spaceship_ramp_cubit.dart';

enum SpaceshipRampArrowSpriteState {
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

class SpaceshipRampState extends Equatable {
  const SpaceshipRampState({
    required this.hits,
    required this.arrowState,
  }) : assert(hits >= 0, "Hits can't be negative");

  const SpaceshipRampState.initial()
      : this(
          hits: 0,
          arrowState: SpaceshipRampArrowSpriteState.inactive,
        );

  final int hits;
  final SpaceshipRampArrowSpriteState arrowState;

  SpaceshipRampState copyWith({
    int? hits,
    SpaceshipRampArrowSpriteState? arrowState,
  }) {
    return SpaceshipRampState(
      hits: hits ?? this.hits,
      arrowState: arrowState ?? this.arrowState,
    );
  }

  @override
  List<Object?> get props => [hits, arrowState];
}
