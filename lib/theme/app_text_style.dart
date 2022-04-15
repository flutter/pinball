import 'package:flutter/widgets.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_components/gen/fonts.gen.dart';

const _fontPackage = 'pinball_components';
const _primaryFontFamily = FontFamily.pixeloidSans;

/// App Text Style Definitions
abstract class AppTextStyle {
  /// Headline 2 Text Style with font size 28.
  static const headline2 = TextStyle(
    fontSize: 28,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  /// Headline 3 Text Style with font size 24.
  static const headline3 = TextStyle(
    fontSize: 24,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  /// Headline 4 Text Style with font size 20 and white color.
  static const headline4 = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  /// Subtitle 1 Text Style with font size 10.
  static const subtitle1 = TextStyle(
    fontSize: 10,
    fontFamily: _primaryFontFamily,
    package: _fontPackage,
  );
}
