import 'package:flutter/widgets.dart';
import 'package:pinball_ui/gen/fonts.gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

const _fontPackage = 'pinball_components';
const _primaryFontFamily = FontFamily.pixeloidSans;

/// Different [TextStyle] used in the game
abstract class PinballTextStyle {
  /// Font size: 28 | Color: white
  static const displayLarge = TextStyle(
    fontSize: 28,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    color: PinballColors.white,
  );

  /// Font size: 24 | Color: white
  static const displayMedium = TextStyle(
    fontSize: 24,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    color: PinballColors.white,
  );

  /// Font size: 20 | Color: darkBlue
  static const displaySmall = TextStyle(
    color: PinballColors.darkBlue,
    fontSize: 20,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    fontWeight: FontWeight.bold,
  );

  /// Font size: 16 | Color: white
  static const headlineMedium = TextStyle(
    color: PinballColors.white,
    fontSize: 16,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  /// Font size: 214| Color: white
  static const headlineSmall = TextStyle(
    color: PinballColors.white,
    fontSize: 14,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  /// Font size: 12 | Color: white
  static const titleMedium = TextStyle(
    fontSize: 12,
    fontFamily: _primaryFontFamily,
    package: _fontPackage,
    color: PinballColors.yellow,
  );
}
