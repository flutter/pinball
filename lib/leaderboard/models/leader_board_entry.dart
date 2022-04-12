import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template leaderboard_entry}
/// A model representing a leaderboard entry containing the ranking position,
/// player's initials, score, and chosen character.
///
/// {@endtemplate}
class LeaderboardEntry {
  /// {@macro leaderboard_entry}
  LeaderboardEntry({
    required this.rank,
    required this.playerInitials,
    required this.score,
    required this.character,
  });

  /// Ranking position for [LeaderboardEntry].
  final String rank;

  /// Player's chosen initials for [LeaderboardEntry].
  final String playerInitials;

  /// Score for [LeaderboardEntry].
  final int score;

  /// [CharacterTheme] for [LeaderboardEntry].
  final AssetGenImage character;
}

/// Converts [LeaderboardEntryData] from repository to [LeaderboardEntry].
extension LeaderboardEntryDataX on LeaderboardEntryData {
  /// Conversion method to [LeaderboardEntry]
  LeaderboardEntry toEntry(int position) {
    return LeaderboardEntry(
      rank: position.toString(),
      playerInitials: playerInitials,
      score: score,
      character: character.toTheme.character,
    );
  }
}

/// Converts [CharacterType] to [CharacterTheme] to show on UI character theme
/// from repository.
extension CharacterTypeX on CharacterType {
  /// Conversion method to [CharacterTheme]
  CharacterTheme get toTheme {
    switch (this) {
      case CharacterType.dash:
        return const DashTheme();
      case CharacterType.sparky:
        return const SparkyTheme();
      case CharacterType.android:
        return const AndroidTheme();
      case CharacterType.dino:
        return const DinoTheme();
    }
  }
}

/// Converts [CharacterTheme] to [CharacterType] to persist at repository the
/// character theme from UI.
extension CharacterThemeX on CharacterTheme {
  /// Conversion method to [CharacterType]
  CharacterType get toType {
    switch (runtimeType) {
      case DashTheme:
        return CharacterType.dash;
      case SparkyTheme:
        return CharacterType.sparky;
      case AndroidTheme:
        return CharacterType.android;
      case DinoTheme:
        return CharacterType.dino;
      default:
        return CharacterType.dash;
    }
  }
}
