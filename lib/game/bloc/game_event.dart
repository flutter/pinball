// ignore_for_file: public_member_api_docs

part of 'game_bloc.dart';

@immutable
abstract class GameEvent extends Equatable {
  const GameEvent();
}

/// {@template round_lost_game_event}
/// Event added when a user drops all balls off the screen and loses a round.
/// {@endtemplate}
class RoundLost extends GameEvent {
  /// {@macro round_lost_game_event}
  const RoundLost();

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
/// Added when a multiplier is gained.
/// {@endtemplate}
class MultiplierIncreased extends GameEvent {
  /// {@macro multiplier_increased_game_event}
  const MultiplierIncreased();

  @override
  List<Object?> get props => [];
}
