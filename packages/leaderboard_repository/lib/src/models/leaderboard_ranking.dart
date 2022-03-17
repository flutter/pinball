import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

/// {@template leaderboard_ranking}
/// Contains [ranking] for a single [LeaderboardEntry] and the number of players
/// the [ranking] is [outOf].
/// {@endtemplate}
class LeaderboardRanking extends Equatable {
  /// {@macro leaderboard_ranking}
  const LeaderboardRanking({required this.ranking, required this.outOf});

  /// Place ranking by score for a [LeaderboardEntry].
  final int ranking;

  /// Number of [LeaderboardEntry]s at the time of score entry.
  final int outOf;

  @override
  List<Object> get props => [ranking, outOf];
}
