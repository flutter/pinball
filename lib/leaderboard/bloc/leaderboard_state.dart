// ignore_for_file: public_member_api_docs

part of 'leaderboard_bloc.dart';

/// Defines the request status.
enum LeaderboardStatus {
  /// Request is being loaded.
  loading,

  /// Request was processed successfully and received a valid response.
  success,

  /// Request was processed unsuccessfully and received an error.
  error,
}

/// {@template leaderboard_state}
/// Represents the state of the leaderboard.
/// {@endtemplate}
class LeaderboardState extends Equatable {
  /// {@macro leaderboard_state}
  const LeaderboardState({
    required this.status,
    required this.ranking,
    required this.leaderboard,
  });

  const LeaderboardState.initial()
      : status = LeaderboardStatus.loading,
        ranking = const LeaderboardRanking(
          ranking: 0,
          outOf: 0,
        ),
        leaderboard = const [];

  /// The current [LeaderboardStatus] of the state.
  final LeaderboardStatus status;

  /// Rank of the current player.
  final LeaderboardRanking ranking;

  /// List of top-ranked players.
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
