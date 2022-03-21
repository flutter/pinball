part of 'leaderboard_bloc.dart';

/// Defines the request status.
enum LeaderboardStatus {
  /// Request is being loaded.
  loading,

  /// Everything run ok and received response.
  success,

  /// There were some error on request.
  error,
}

/// {@template leaderboard_state}
/// Represents the state of the leaderboard.
/// {@endtemplate}
class LeaderboardState extends Equatable {
  /// {@macro leaderboard_state}
  const LeaderboardState({
    this.status = LeaderboardStatus.loading,
    this.ranking = const LeaderboardRanking(
      ranking: 0,
      outOf: 0,
    ),
    this.leaderboard = const [],
  });

  /// The current [LeaderboardStatus] of the state
  final LeaderboardStatus status;

  /// Rank of the current player.
  final LeaderboardRanking ranking;

  /// List of users at leaderboard.
  final List<LeaderboardEntry> leaderboard;

  @override
  List<Object> get props => [status, ranking, leaderboard];

  /// Method to copy [LeaderboardState] modifying only explicit params and
  /// keeping others.
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
