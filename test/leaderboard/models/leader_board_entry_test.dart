// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/leaderboard/models/leader_board_entry.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('LeaderboardEntry', () {
    group('toEntry', () {
      test('returns the correct from a to entry data', () {
        expect(
          LeaderboardEntryData.empty.toEntry(1),
          LeaderboardEntry(
            rank: '1',
            playerInitials: '',
            score: 0,
            character: CharacterType.dash.toTheme.leaderboardIcon,
          ),
        );
      });
    });

    group('CharacterType', () {
      test('toTheme returns the correct theme', () {
        expect(CharacterType.dash.toTheme, equals(DashTheme()));
        expect(CharacterType.sparky.toTheme, equals(SparkyTheme()));
        expect(CharacterType.android.toTheme, equals(AndroidTheme()));
        expect(CharacterType.dino.toTheme, equals(DinoTheme()));
      });
    });

    group('CharacterTheme', () {
      test('toType returns the correct type', () {
        expect(DashTheme().toType, equals(CharacterType.dash));
        expect(SparkyTheme().toType, equals(CharacterType.sparky));
        expect(AndroidTheme().toType, equals(CharacterType.android));
        expect(DinoTheme().toType, equals(CharacterType.dino));
      });
    });
  });
}
