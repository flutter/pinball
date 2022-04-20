import 'package:pinball_components/gen/fonts.gen.dart';

const String _fontPath = 'packages/pinball_components/';

/// Class with the fonts available on the pinball game
class PinballFonts {
  PinballFonts._();

  /// Mono variation of the Pixeloid font
  static const String pixeloidMono = '$_fontPath/${FontFamily.pixeloidMono}';

  /// Sans variation of the Pixeloid font
  static const String pixeloidSans = '$_fontPath/${FontFamily.pixeloidSans}';
}
