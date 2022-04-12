import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template android_theme}
/// Defines Android character theme assets and attributes.
/// {@endtemplate}
class AndroidTheme extends CharacterTheme {
  /// {@macro android_theme}
  const AndroidTheme();

  @override
  String get name => 'Android';

  @override
  Color get ballColor => Colors.green;

  @override
  AssetGenImage get character => Assets.images.android.character;

  @override
  AssetGenImage get background => Assets.images.android.background;

  @override
  AssetGenImage get icon => Assets.images.android.icon;
}
