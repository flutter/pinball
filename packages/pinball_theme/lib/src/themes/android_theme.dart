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
  AssetGenImage get characterAsset => Assets.images.android;

  @override
  AssetGenImage get backgroundAsset => Assets.images.androidBackground;

  @override
  AssetGenImage get placeholderAsset => Assets.images.androidPlaceholder;

  @override
  AssetGenImage get iconAsset => Assets.images.androidIcon;
}
