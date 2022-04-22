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

/// {@template multiplier_increased_game_event}
/// Event added when multiplier is being increased.
/// {@endtemplate}
class MultiplierIncreased extends GameEvent {
  /// {@macro multiplier_increased_game_event}
  const MultiplierIncreased();

  @override
  List<Object?> get props => [];
}

/// {@template multiplier_applied_game_event}
/// Event added when multiplier is applied to score.
/// {@endtemplate}
class MultiplierApplied extends GameEvent {
  /// {@macro multiplier_applied_game_event}
  const MultiplierApplied();

  @override
  List<Object?> get props => [];
}

/// {@template multiplier_reset_game_event}
/// Event added when multiplier is reset.
/// {@endtemplate}
class MultiplierReset extends GameEvent {
  /// {@macro multiplier_reset_game_event}
  const MultiplierReset();

  @override
  List<Object?> get props => [];
}
