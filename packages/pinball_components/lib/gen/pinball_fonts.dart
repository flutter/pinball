import 'package:pinball_components/gen/fonts.gen.dart';

String _prefixFont(String font) {
  return 'packages/pinball_components/$font';
}

/// Class with the fonts available on the pinball game
class PinballFonts {
  PinballFonts._();

  /// Mono variation of the Pixeloid font
  static final String pixeloidMono = _prefixFont(FontFamily.pixeloidMono);

  /// Sans variation of the Pixeloid font
  static final String pixeloidSans = _prefixFont(FontFamily.pixeloidMono);
}
