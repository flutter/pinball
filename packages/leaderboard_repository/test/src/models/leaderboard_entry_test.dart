import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardEntry', () {
    const data = <String, dynamic>{
      'username': 'test123',
      'score': 1500,
      'character': 'dash',
    };

    const leaderboardEntry = LeaderboardEntry(
      username: 'test123',
      score: 1500,
      character: CharacterType.dash,
    );

    test('can be instantiated', () {
      const leaderboardEntry = LeaderboardEntry.empty;

      expect(leaderboardEntry, isNotNull);
    });

    test('supports value equality.', () {
      const leaderboardEntry = LeaderboardEntry.empty;
      const leaderboardEntry2 = LeaderboardEntry.empty;

      expect(leaderboardEntry, equals(leaderboardEntry2));
    });

    test('can be converted to json', () {
      const leaderboardEntry = LeaderboardEntry(
        username: 'test123',
        score: 1500,
        character: CharacterType.dash,
      );

      expect(leaderboardEntry.toJson(), equals(data));
    });

    test('can be obtained from json', () {
      final leaderboardEntryFrom = LeaderboardEntry.fromJson(data);

      expect(leaderboardEntry, equals(leaderboardEntryFrom));
    });
  });
}
