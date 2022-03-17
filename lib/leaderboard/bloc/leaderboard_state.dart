part of 'leaderboard_bloc.dart';

enum LeaderboardStatus { loading, success, error }

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LeaderboardStatus.loading,
    this.ranking = const LeaderboardRanking(
      ranking: 0,
      outOf: 0,
    ),
    this.leaderboard = const [],
  });

  final LeaderboardStatus status;
  final LeaderboardRanking ranking;
  final List<LeaderboardEntry> leaderboard;

  @override
  List<Object> get props => [status, ranking, leaderboard];

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    LeaderboardRanking? ranking,
    List<LeaderboardEntry>? leaderboard,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      ranking: ranking ?? this.ranking,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }
}

enum CharacterType { dash, sparky, android, dino }

class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.playerInitials,
    required this.score,
    required this.character,
  });

  final String playerInitials;
  final int score;
  final CharacterType character;

  @override
  List<Object?> get props => [playerInitials, character, score];
}

class LeaderboardRanking extends Equatable {
  const LeaderboardRanking({
    required this.ranking,
    required this.outOf,
  });

  final int ranking;
  final int outOf;

  @override
  List<Object?> get props => [ranking, outOf];
}
