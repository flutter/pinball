// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/leaderboard/leaderboard.dart';

void main() {
  group('GameEvent', () {
    group('Top10Fetched', () {
      test('can be instantiated', () {
        expect(const Top10Fetched(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          Top10Fetched(),
          equals(const Top10Fetched()),
        );
      });
    });

    group('LeaderboardEntryAdded', () {
      const leaderboardEntry = LeaderboardEntry(
        playerInitials: 'ABC',
        score: 1500,
        character: CharacterType.dash,
      );

      test('can be instantiated', () {
        expect(const LeaderboardEntryAdded(entry: leaderboardEntry), isNotNull);
      });

      test('supports value equality', () {
        expect(
          LeaderboardEntryAdded(entry: leaderboardEntry),
          equals(const LeaderboardEntryAdded(entry: leaderboardEntry)),
        );
      });
    });
  });
}
