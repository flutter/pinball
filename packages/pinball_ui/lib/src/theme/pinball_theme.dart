import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Pinball theme
class PinballTheme {
  /// Standard [ThemeData] for Pinball UI
  static ThemeData get standard {
    return ThemeData(
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: PinballTextStyle.displayLarge,
      displayMedium: PinballTextStyle.displayMedium,
      displaySmall: PinballTextStyle.displaySmall,
      headlineMedium: PinballTextStyle.headlineMedium,
      headlineSmall: PinballTextStyle.headlineSmall,
      titleMedium: PinballTextStyle.titleMedium,
    );
  }
}
