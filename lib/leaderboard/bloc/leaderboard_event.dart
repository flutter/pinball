part of 'leaderboard_bloc.dart';

/// {@template leaderboard_event}
/// Represents the events available for [LeaderboardBloc].
/// {endtemplate}
abstract class LeaderboardEvent extends Equatable {
  /// {@macro leaderboard_event}
  const LeaderboardEvent();
}

/// {@template top_10_fetched}
/// Request the top 10 [LeaderboardEntry]s.
/// {endtemplate}
class Top10Fetched extends LeaderboardEvent {
  /// {@macro top_10_fetched}
  const Top10Fetched();

  @override
  List<Object?> get props => [];
}

/// {@template leaderboard_entry_added}
/// Writes a new [LeaderboardEntry].
///
/// Should be added when a player finishes a game.
/// {endtemplate}
class LeaderboardEntryAdded extends LeaderboardEvent {
  /// {@macro leaderboard_entry_added}
  const LeaderboardEntryAdded({required this.entry});

  /// [LeaderboardEntry] to be written to the remote storage.
  final LeaderboardEntry entry;

  @override
  List<Object?> get props => [entry];
}
