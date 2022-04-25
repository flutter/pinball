// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('LeaderboardState', () {
    test('supports value equality', () {
      expect(
        LeaderboardState.initial(),
        equals(
          LeaderboardState.initial(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          LeaderboardState.initial(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      final leaderboardEntry = LeaderboardEntry(
        rank: '1',
        playerInitials: 'ABC',
        score: 1500,
        character: DashTheme().leaderboardIcon,
      );

      test(
        'copies correctly '
        'when no argument specified',
        () {
          const leaderboardState = LeaderboardState.initial();
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
          const leaderboardState = LeaderboardState.initial();
          final otherLeaderboardState = LeaderboardState(
            status: LeaderboardStatus.success,
            ranking: LeaderboardRanking(ranking: 0, outOf: 0),
            leaderboard: [leaderboardEntry],
          );
          expect(leaderboardState, isNot(equals(otherLeaderboardState)));

          expect(
            leaderboardState.copyWith(
              status: otherLeaderboardState.status,
              ranking: otherLeaderboardState.ranking,
              leaderboard: otherLeaderboardState.leaderboard,
            ),
            equals(otherLeaderboardState),
          );
        },
      );
    });
  });
}
