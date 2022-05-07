part of 'backbox_bloc.dart';

/// {@template backbox_state}
/// The base state for all [BackboxState].
/// {@endtemplate backbox_state}
abstract class BackboxState extends Equatable {
  /// {@macro backbox_state}
  const BackboxState();
}

/// Loading state for the backbox.
class LoadingState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// {@template leaderboard_success_state}
/// State when the leaderboard was successfully loaded.
/// {@endtemplate}
class LeaderboardSuccessState extends BackboxState {
  /// {@macro leaderboard_success_state}
  const LeaderboardSuccessState({required this.entries});

  /// Current entries
  final List<LeaderboardEntryData> entries;

  @override
  List<Object?> get props => [entries];
}

/// State when the leaderboard failed to load.
class LeaderboardFailureState extends BackboxState {
  @override
  List<Object?> get props => [];
}

/// {@template initials_form_state}
/// State when the user is inputting their initials.
/// {@endtemplate}
class InitialsFormState extends BackboxState {
  /// {@macro initials_form_state}
  const InitialsFormState({
    required this.score,
    required this.character,
  }) : super();

  /// Player's score.
  final int score;

  /// Player's character.
  final CharacterTheme character;

  @override
  List<Object?> get props => [score, character];
}

/// {@template initials_success_state}
/// State when the score and initials were successfully submitted.
/// {@endtemplate}
class InitialsSuccessState extends BackboxState {
  /// {@macro initials_success_state}
  const InitialsSuccessState({
    required this.score,
  }) : super();

  /// Player's score.
  final int score;

  @override
  List<Object?> get props => [score];
}

/// State when the initials submission failed.
class InitialsFailureState extends BackboxState {
  const InitialsFailureState({
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

/// {@template share_state}
/// State when the user is sharing their score.
/// {@endtemplate}
class ShareState extends BackboxState {
  /// {@macro share_state}
  const ShareState({
    required this.score,
  }) : super();

  /// Player's score.
  final int score;

  @override
  List<Object?> get props => [score];
}
