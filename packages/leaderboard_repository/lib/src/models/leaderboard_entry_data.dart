import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_entry_data.g.dart';

/// Google character type associated with a [LeaderboardEntryData].
enum CharacterType {
  /// Dash character.
  dash,

  /// Sparky character.
  sparky,

  /// Android character.
  android,

  /// Dino character.
  dino,
}

/// {@template leaderboard_entry_data}
/// A model representing a leaderboard entry containing the player's initials,
/// score, and chosen character.
///
/// Stored in Firestore `leaderboard` collection.
///
/// Example:
/// ```json
/// {
///   "playerInitials" : "ABC",
///   "score" : 1500,
///   "character" : "dash"
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class LeaderboardEntryData extends Equatable {
  /// {@macro leaderboard_entry_data}
  const LeaderboardEntryData({
    required this.playerInitials,
    required this.score,
    required this.character,
  });

  /// Factory which converts a [Map] into a [LeaderboardEntryData].
  factory LeaderboardEntryData.fromJson(Map<String, dynamic> json) {
    return _$LeaderboardEntryFromJson(json);
  }

  /// Converts the [LeaderboardEntryData] to [Map].
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);

  /// Player's chosen initials for [LeaderboardEntryData].
  ///
  /// Example: 'ABC'.
  @JsonKey(name: 'playerInitials')
  final String playerInitials;

  /// Score for [LeaderboardEntryData].
  ///
  /// Example: 1500.
  @JsonKey(name: 'score')
  final int score;

  /// [CharacterType] for [LeaderboardEntryData].
  ///
  /// Example: [CharacterType.dash].
  @JsonKey(name: 'character')
  final CharacterType character;

  /// An empty [LeaderboardEntryData] object.
  static const empty = LeaderboardEntryData(
    playerInitials: '',
    score: 0,
    character: CharacterType.dash,
  );

  @override
  List<Object?> get props => [playerInitials, score, character];
}
