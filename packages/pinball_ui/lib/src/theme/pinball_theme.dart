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
      headline1: PinballTextStyle.headline1,
      headline2: PinballTextStyle.headline2,
      headline3: PinballTextStyle.headline3,
      headline4: PinballTextStyle.headline4,
      headline5: PinballTextStyle.headline5,
      subtitle1: PinballTextStyle.subtitle1,
      subtitle2: PinballTextStyle.subtitle2,
    );
  }
}
