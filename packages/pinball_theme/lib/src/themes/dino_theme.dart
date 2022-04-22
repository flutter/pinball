import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template dino_theme}
/// Defines Dino character theme assets and attributes.
/// {@endtemplate}
class DinoTheme extends CharacterTheme {
  /// {@macro dino_theme}
  const DinoTheme();

  @override
  String get name => 'Dino';

  @override
  Color get ballColor => Colors.grey;

  @override
  AssetGenImage get character => Assets.images.dino.character;

  @override
  AssetGenImage get background => Assets.images.dino.background;

  @override
  AssetGenImage get icon => Assets.images.dino.icon;

  @override
  AssetGenImage get leaderboardIcon => Assets.images.dino.leaderboardIcon;
}
