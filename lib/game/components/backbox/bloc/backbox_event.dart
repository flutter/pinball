part of 'backbox_bloc.dart';

/// {@template backbox_event}
/// Base class for backbox events.
/// {@endtemplate}
abstract class BackboxEvent extends Equatable {
  /// {@macro backbox_event}
  const BackboxEvent();
}

/// {@template player_initials_requested}
/// Event that triggers the user initials display.
/// {@endtemplate}
class PlayerInitialsRequested extends BackboxEvent {
  /// {@macro player_initials_requested}
  const PlayerInitialsRequested({
    required this.score,
    required this.character,
  });

  /// Player's score.
  final int score;

  /// Player's character.
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, character];
}

/// {@template player_initials_submitted}
/// Event that submits the user score and initials.
/// {@endtemplate}
class PlayerInitialsSubmitted extends BackboxEvent {
  /// {@macro player_initials_submitted}
  const PlayerInitialsSubmitted({
    required this.score,
    required this.initials,
    required this.character,
  });

  /// Player's score.
  final int score;

  /// Player's initials.
  final String initials;

  /// Player's character.
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, initials, character];
}

/// Event that triggers the fetching of the leaderboard
class LeaderboardRequested extends BackboxEvent {
  @override
  List<Object?> get props => [];
}
