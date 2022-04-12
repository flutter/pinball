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
  AssetGenImage get characterAsset => Assets.images.dino;

  @override
  AssetGenImage get backgroundAsset => Assets.images.dinoBackground;

  @override
  AssetGenImage get placeholderAsset => Assets.images.dinoPlaceholder;

  @override
  AssetGenImage get iconAsset => Assets.images.dinoIcon;
}
