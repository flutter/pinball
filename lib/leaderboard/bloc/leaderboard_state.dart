part of 'leaderboard_bloc.dart';

enum LeaderboardStatus { loading, success, error }

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LeaderboardStatus.loading,
    this.ranking = const [],
  });

  final LeaderboardStatus status;
  final List<Competitor> ranking;

  @override
  List<Object> get props => [status, ranking];

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<Competitor>? ranking,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      ranking: ranking ?? this.ranking,
    );
  }
}

class Competitor extends Equatable {
  const Competitor({
    required this.rank,
    required this.characterTheme,
    required this.initials,
    required this.score,
  });

  final int rank;
  final CharacterTheme characterTheme;
  final String initials;
  final int score;

  @override
  List<Object?> get props => [rank, characterTheme, initials, score];
}
