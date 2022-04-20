// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_components/pinball_components.dart';

const _fontPackage = 'pinball_components';
const _primaryFontFamily = PinballFonts.pixeloidSans;

abstract class AppTextStyle {
  static const headline1 = TextStyle(
    fontSize: 28,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  static const headline2 = TextStyle(
    fontSize: 24,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  static const headline3 = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    package: _fontPackage,
    fontFamily: _primaryFontFamily,
  );

  static const subtitle1 = TextStyle(
    fontSize: 10,
    fontFamily: _primaryFontFamily,
    package: _fontPackage,
  );
}
