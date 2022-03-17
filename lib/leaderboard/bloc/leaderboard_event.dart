part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class Top10Fetched extends LeaderboardEvent {
  const Top10Fetched();
}

class LeaderboardEntryAdded extends LeaderboardEvent {
  const LeaderboardEntryAdded({required this.entry});

  final LeaderboardEntry entry;

  @override
  List<Object?> get props => [entry];
}
