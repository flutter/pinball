// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryData _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntryData(
      playerInitials: json['playerInitials'] as String,
      score: json['score'] as int,
      character: $enumDecode(_$CharacterTypeEnumMap, json['character']),
    );

Map<String, dynamic> _$LeaderboardEntryToJson(LeaderboardEntryData instance) =>
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
