part of 'leaderboard_bloc.dart';

/// Represents the events available for [LeaderboardBloc].
abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

/// Request the top 10 from leaderboard.
class Top10Fetched extends LeaderboardEvent {
  const Top10Fetched();
}

/// Insert new entry at leaderboard when user ends game.
class LeaderboardEntryAdded extends LeaderboardEvent {
  const LeaderboardEntryAdded({required this.entry});

  /// Current entry to persist at leaderboard.
  final LeaderboardEntry entry;

  @override
  List<Object?> get props => [entry];
}
