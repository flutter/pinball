// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('LeaderboardState', () {
    test('supports value equality', () {
      expect(
        LeaderboardState(),
        equals(
          LeaderboardState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          LeaderboardState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const leaderboardState = LeaderboardState();
          expect(
            leaderboardState.copyWith(),
            equals(leaderboardState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const leaderboardState = LeaderboardState();
          final otherLeaderboardState = LeaderboardState(
            status: LeaderboardStatus.success,
            ranking: const [
              Competitor(
                rank: 1,
                characterTheme: DashTheme(),
                initials: 'ABC',
                score: 10,
              ),
            ],
          );
          expect(leaderboardState, isNot(equals(otherLeaderboardState)));

          expect(
            leaderboardState.copyWith(
              status: otherLeaderboardState.status,
              ranking: otherLeaderboardState.ranking,
            ),
            equals(otherLeaderboardState),
          );
        },
      );
    });
  });
}
