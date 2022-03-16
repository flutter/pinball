// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntry(
      playerInitials: json['playerInitials'] as String,
      score: json['score'] as int,
      character: $enumDecode(_$CharacterTypeEnumMap, json['character']),
    );

Map<String, dynamic> _$LeaderboardEntryToJson(LeaderboardEntry instance) =>
    <String, dynamic>{
      'playerInitials': instance.playerInitials,
      'score': instance.score,
      'character': _$CharacterTypeEnumMap[instance.character],
    };

const _$CharacterTypeEnumMap = {
  CharacterType.dash: 'dash',
  CharacterType.sparky: 'sparky',
  CharacterType.android: 'android',
  CharacterType.dino: 'dino',
};
