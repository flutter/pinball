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

class BonusLetterActivated extends GameEvent {
  const BonusLetterActivated(this.letterIndex)
      : assert(
          letterIndex < GameBloc.bonusWord.length,
          'Index must be smaller than the length of the word',
        );

  final int letterIndex;

  @override
  List<Object?> get props => [letterIndex];
}

class DashNestActivated extends GameEvent {
  const DashNestActivated(this.nestId);

  final String nestId;

  @override
  List<Object?> get props => [nestId];
}
