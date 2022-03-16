import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/leaderboard/leaderboard.dart';

void main() {
  group('GameEvent', () {
    group('LeaderboardRequested', () {
      test('can be instantiated', () {
        expect(const LeaderboardRequested(), isNotNull);
      });

      test('supports value equality', () {
        expect(
          LeaderboardRequested(),
          equals(const LeaderboardRequested()),
        );
      });
    });
  });
}
