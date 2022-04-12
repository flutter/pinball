import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template dino_theme}
/// Defines Dino character theme assets and attributes.
/// {@endtemplate}
class DinoTheme extends CharacterTheme {
  /// {@macro dino_theme}
  const DinoTheme();

  @override
  Color get ballColor => Colors.grey;

  @override
  AssetGenImage get characterAsset => Assets.images.dino.character;
}
