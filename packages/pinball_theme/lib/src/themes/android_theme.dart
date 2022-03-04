import 'package:flutter/material.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template android_theme}
/// Defines Android character theme assets and attributes.
/// {@endtemplate}
class AndroidTheme extends CharacterTheme {
  /// {@macro android_theme}
  const AndroidTheme();

  @override
  Color get ballColor => Colors.green;
}
