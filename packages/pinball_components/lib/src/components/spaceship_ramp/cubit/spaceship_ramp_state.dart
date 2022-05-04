// ignore_for_file: public_member_api_docs

part of 'spaceship_ramp_cubit.dart';

class SpaceshipRampState extends Equatable {
  const SpaceshipRampState({
    required this.hits,
  }) : assert(hits >= 0, "Hits can't be negative");

  const SpaceshipRampState.initial() : this(hits: 0);

  final int hits;

  SpaceshipRampState copyWith({
    int? hits,
  }) {
    return SpaceshipRampState(
      hits: hits ?? this.hits,
    );
  }

  @override
  List<Object?> get props => [hits];
}
