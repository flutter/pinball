import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template dash_theme}
/// Defines Dash character theme assets and attributes.
/// {@endtemplate}
class DashTheme extends CharacterTheme {
  /// {@macro dash_theme}
  const DashTheme();

  @override
  String get name => 'Dash';

  @override
  Color get ballColor => Colors.blue;

  @override
  AssetGenImage get character => Assets.images.dash.character;

  @override
  AssetGenImage get background => Assets.images.dash.background;

  @override
  AssetGenImage get icon => Assets.images.dash.icon;
}
