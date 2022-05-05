part of 'backbox_bloc.dart';

/// {@template backbox_event}
/// Base class for backbox events
/// {@endtemplate}
abstract class BackboxEvent extends Equatable {
  /// {@macro backbox_event}
  const BackboxEvent();
}

/// {@template player_initials_requested}
/// Event that triggers the user initials display
/// {@endtemplate}
class PlayerInitialsRequested extends BackboxEvent {
  /// {@template player_initials_requested}
  const PlayerInitialsRequested({
    required this.score,
    required this.character,
  });

  /// Player's score
  final int score;

  /// Player's character
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, character];
}

/// {@template player_initials_submited}
/// Event that submits the user score and initials
/// {@endtemplate}
class PlayerInitialsSubmited extends BackboxEvent {
  /// {@template player_initials_requested}
  const PlayerInitialsSubmited({
    required this.score,
    required this.initials,
    required this.character,
  });

  /// Player's score
  final int score;

  /// Player's initials
  final String initials;

  /// Player's character
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, initials, character];
}
