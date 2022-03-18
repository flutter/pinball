part of 'leaderboard_bloc.dart';

/// {@template leaderboard_event}
/// Represents the events available for [LeaderboardBloc].
/// {endtemplate}
abstract class LeaderboardEvent extends Equatable {
  /// {@macro leaderboard_event}
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

/// {@template top_10_fetched}
/// Request the top 10 from leaderboard.
/// {endtemplate}
class Top10Fetched extends LeaderboardEvent {
  /// {@macro top_10_fetched}
  const Top10Fetched();
}

/// {@template leaderboard_entry_added}
/// Insert new entry at leaderboard when user ends game.
/// {endtemplate}
class LeaderboardEntryAdded extends LeaderboardEvent {
  /// {@macro leaderboard_entry_added}
  const LeaderboardEntryAdded({required this.entry});

  /// Current entry to persist at leaderboard.
  final LeaderboardEntry entry;

  @override
  List<Object?> get props => [entry];
}
