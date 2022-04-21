// ignore_for_file: public_member_api_docs

part of 'game_bloc.dart';

@immutable
abstract class GameEvent extends Equatable {
  const GameEvent();
}

/// {@template ball_lost_game_event}
/// Event added when a user drops a ball off the screen.
/// {@endtemplate}
class BallLost extends GameEvent {
  /// {@macro ball_lost_game_event}
  const BallLost();

  @override
  List<Object?> get props => [];
}

/// {@template scored_game_event}
/// Event added when a user increases their score.
/// {@endtemplate}
class Scored extends GameEvent {
  /// {@macro scored_game_event}
  const Scored({
    required this.points,
  }) : assert(points > 0, 'Points must be greater than 0');

  final int points;

  @override
  List<Object?> get props => [points];
}

class BonusActivated extends GameEvent {
  const BonusActivated(this.bonus);

  final GameBonus bonus;

  @override
  List<Object?> get props => [bonus];
}

class SparkyTurboChargeActivated extends GameEvent {
  const SparkyTurboChargeActivated();

  @override
  List<Object?> get props => [];
}

/// {@template increased_multiplier_game_event}
/// Event added when multiplier is being increased.
/// {@endtemplate}
class IncreasedMultiplier extends GameEvent {
  /// {@macro increased_multiplier_game_event}
  const IncreasedMultiplier({
    required this.increase,
  }) : assert(increase > 0, 'Increase must be greater than 0');

  final int increase;

  @override
  List<Object?> get props => [increase];
}

/// {@template applied_multiplier_game_event}
/// Event added when multiplier is applied to score.
/// {@endtemplate}
class AppliedMultiplier extends GameEvent {
  /// {@macro applied_multiplier_game_event}
  const AppliedMultiplier();

  @override
  List<Object?> get props => [];
}

/// {@template reset_multiplier_game_event}
/// Event added when multiplier is reset.
/// {@endtemplate}
class ResetMultiplier extends GameEvent {
  /// {@macro reset_multiplier_game_event}
  const ResetMultiplier();

  @override
  List<Object?> get props => [];
}
