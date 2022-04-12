import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template sparky_theme}
/// Defines Sparky character theme assets and attributes.
/// {@endtemplate}
class SparkyTheme extends CharacterTheme {
  /// {@macro sparky_theme}
  const SparkyTheme();

  @override
  Color get ballColor => Colors.orange;

  @override
  String get name => 'Sparky';

  @override
  AssetGenImage get characterAsset => Assets.images.sparky;

  @override
  AssetGenImage get backgroundAsset => Assets.images.sparkyBackground;

  @override
  AssetGenImage get placeholderAsset => Assets.images.sparkyPlaceholder;

  @override
  AssetGenImage get iconAsset => Assets.images.sparkyIcon;
}
