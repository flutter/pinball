import 'package:flutter/widgets.dart';
import 'package:pinball_components/gen/fonts.gen.dart';

/// App Text Style Definitions
abstract class AppTextStyle {
  /// Headline 1 Text Style
  static const headline1 = TextStyle(
    fontSize: 36,
    height: 1.25,
    package: 'pinball_components',
    fontFamily: FontFamily.pixeloidSans,
  );

  /// Headline 2 Text Style
  static const headline2 = TextStyle(
    fontSize: 28,
    height: 1.25,
    package: 'pinball_components',
    fontFamily: FontFamily.pixeloidSans,
  );

  /// Headline 3 Text Style
  static const headline3 = TextStyle(
    fontSize: 24,
    height: 1.25,
    package: 'pinball_components',
    fontFamily: FontFamily.pixeloidSans,
  );

  /// Headline 4 Text Style
  static const headline4 = TextStyle(
    fontSize: 20,
    fontFamily: FontFamily.pixeloidSans,
    letterSpacing: 3,
    package: 'pinball_components',
  );

  /// Headline 5 Text Style
  static const headline5 = TextStyle(
    fontSize: 18,
    fontFamily: FontFamily.pixeloidSans,
    height: 1.25,
    package: 'pinball_components',
  );

  /// Headline 6 Text Style
  static const headline6 = TextStyle(
    fontSize: 16,
    fontFamily: FontFamily.pixeloidSans,
    height: 1.25,
    package: 'pinball_components',
  );

  /// Subtitle 1 Text Style
  static const subtitle1 = TextStyle(
    fontSize: 10,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Subtitle 2 Text Style
  static const subtitle2 = TextStyle(
    fontSize: 14,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Body Text 1 Text Style
  static const bodyText1 = TextStyle(
    fontSize: 16,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Body Text 2 Text Style (the default)
  static const bodyText2 = TextStyle(
    fontSize: 14,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Button Text Style
  static const button = TextStyle(
    fontSize: 18,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Caption Text Style
  static const caption = TextStyle(
    fontSize: 12,
    fontFamily: FontFamily.pixeloidSans,
    package: 'pinball_components',
  );

  /// Overline Text Style
  static const overline = TextStyle(
    fontSize: 12,
    letterSpacing: 1.15,
    package: 'pinball_components',
    fontFamily: FontFamily.pixeloidSans,
    decoration: TextDecoration.underline,
  );
}
