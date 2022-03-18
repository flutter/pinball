import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardRanking', () {
    test('can be instantiated', () {
      const leaderboardRanking = LeaderboardRanking(ranking: 1, outOf: 1);

      expect(leaderboardRanking, isNotNull);
    });

    test('supports value equality.', () {
      const leaderboardRanking = LeaderboardRanking(ranking: 1, outOf: 1);
      const leaderboardRanking2 = LeaderboardRanking(ranking: 1, outOf: 1);

      expect(leaderboardRanking, equals(leaderboardRanking2));
    });
  });
}
