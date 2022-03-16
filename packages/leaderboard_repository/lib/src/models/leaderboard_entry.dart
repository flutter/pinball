import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_entry.g.dart';

/// Google character type associated with a [LeaderboardEntry].
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

/// {@template leaderboard_entry}
/// A model representing a leaderboard entry containing a score and a username.
///
/// Stored in Firestore `leaderboard` collection.
///
/// Example:
/// ```json
/// {
///   "username" : "test123",
///   "score" : 1500,
///   "character" : "dash"
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class LeaderboardEntry extends Equatable {
  /// {@macro leaderboard_entry}
  const LeaderboardEntry({
    required this.username,
    required this.score,
    required this.character,
  });

  /// Factory which converts a [Map] into a [LeaderboardEntry].
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return _$LeaderboardEntryFromJson(json);
  }

  /// Converts the [LeaderboardEntry] to [Map].
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);

  /// Username for [LeaderboardEntry].
  ///
  /// Example: 'test123'.
  @JsonKey(name: 'username')
  final String username;

  /// Score for [LeaderboardEntry].
  ///
  /// Example: 1500.
  @JsonKey(name: 'score')
  final int score;

  /// [CharacterType] for [LeaderboardEntry].
  ///
  /// Example: [CharacterType.dash].
  @JsonKey(name: 'character')
  final CharacterType character;

  /// An empty [LeaderboardEntry] object.
  static const empty = LeaderboardEntry(
    username: '',
    score: 0,
    character: CharacterType.dash,
  );

  @override
  List<Object?> get props => [username, score, character];
}
