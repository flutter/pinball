part of 'backbox_bloc.dart';

/// {@template backbox_state}
/// The base state for all [BackboxState]
/// {@endtemplate backbox_state}
abstract class BackboxState extends Equatable {
  /// {@macro backbox_state}
  const BackboxState();
}

/// Loading state for the backbox
class LoadingState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// Failure state for the backbox
class FailureState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// State when the leaderboard was successfully loaded
class LeaderboardSuccessState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// State when the leaderboard was successfully loaded
class LeaderboardFailureState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// {@template initials_form_state}
/// State when the user is inputting their initials
/// {@endtemplate}
class InitialsFormState extends BackboxState {
  /// {@macro initials_form_state}
  const InitialsFormState({
    required this.score,
    required this.character,
  }) : super();

  /// Player's score
  final int score;

  /// Player's character
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, character];
}

/// State when the leaderboard was successfully loaded
class InitialsSuccessState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// State when the leaderboard was successfully loaded
class InitialsFailureState extends BackboxState {
  @override
  List<Object?> get props => [];
}
