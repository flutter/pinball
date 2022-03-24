import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardEntry', () {
    const data = <String, dynamic>{
      'playerInitials': 'ABC',
      'score': 1500,
      'character': 'dash',
    };

    const leaderboardEntry = LeaderboardEntryData(
      playerInitials: 'ABC',
      score: 1500,
      character: CharacterType.dash,
    );

    test('can be instantiated', () {
      const leaderboardEntry = LeaderboardEntryData.empty;

      expect(leaderboardEntry, isNotNull);
    });

    test('supports value equality.', () {
      const leaderboardEntry = LeaderboardEntryData.empty;
      const leaderboardEntry2 = LeaderboardEntryData.empty;

      expect(leaderboardEntry, equals(leaderboardEntry2));
    });

    test('can be converted to json', () {
      expect(leaderboardEntry.toJson(), equals(data));
    });

    test('can be obtained from json', () {
      final leaderboardEntryFrom = LeaderboardEntryData.fromJson(data);

      expect(leaderboardEntry, equals(leaderboardEntryFrom));
    });
  });
}
