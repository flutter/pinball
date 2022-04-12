import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template dash_theme}
/// Defines Dash character theme assets and attributes.
/// {@endtemplate}
class DashTheme extends CharacterTheme {
  /// {@macro dash_theme}
  const DashTheme();

  @override
  Color get ballColor => Colors.blue;

  @override
  AssetGenImage get characterAsset => Assets.images.dash.character;
}
