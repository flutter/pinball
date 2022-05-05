// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:pinball_ui/gen/fonts.gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

const _fontPackage = 'pinball_components';
const _primaryFontFamily = FontFamily.pixeloidSans;

abstract class PinballTextStyle {
  static const headline1 = TextStyle(
    fontSize: 28,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    color: PinballColors.white,
  );

  static const headline2 = TextStyle(
    fontSize: 24,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    color: PinballColors.white,
  );

  static const headline3 = TextStyle(
    color: PinballColors.darkBlue,
    fontSize: 20,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
    fontWeight: FontWeight.bold,
  );

  static const headline4 = TextStyle(
    color: PinballColors.white,
    fontSize: 16,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  static const subtitle2 = TextStyle(
    color: PinballColors.white,
    fontSize: 16,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  static const subtitle1 = TextStyle(
    fontSize: 12,
    fontFamily: _primaryFontFamily,
    package: _fontPackage,
    color: PinballColors.yellow,
  );
}
