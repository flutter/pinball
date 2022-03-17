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

extension CharacterTypeX on CharacterType {
  CharacterTheme get theme {
    switch (this) {
      case CharacterType.dash:
        return const DashTheme();
      case CharacterType.sparky:
        return const SparkyTheme();
      case CharacterType.android:
        return const AndroidTheme();
      case CharacterType.dino:
        return const DinoTheme();
    }
  }
}

extension CharacterThemeX on CharacterTheme {
  CharacterType get toType {
    switch (this.runtimeType) {
      case DashTheme:
        return CharacterType.dash;
      case SparkyTheme:
        return CharacterType.sparky;
      case AndroidTheme:
        return CharacterType.android;
      case DinoTheme:
        return CharacterType.dino;
      default:
        return CharacterType.dash;
    }
  }
}

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
