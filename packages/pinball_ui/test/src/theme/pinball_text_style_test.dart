import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballTextStyle', () {
    test('headline1 has fontSize 28 and white color', () {
      const style = PinballTextStyle.headline1;
      expect(style.fontSize, 28);
      expect(style.color, PinballColors.white);
    });

    test('headline2 has fontSize 24', () {
      const style = PinballTextStyle.headline2;
      expect(style.fontSize, 24);
    });

    test('headline3 has fontSize 20 and dark blue color', () {
      const style = PinballTextStyle.headline3;
      expect(style.fontSize, 20);
      expect(style.color, PinballColors.darkBlue);
    });

    test('headline4 has fontSize 16 and white color', () {
      const style = PinballTextStyle.headline4;
      expect(style.fontSize, 16);
      expect(style.color, PinballColors.white);
    });

    test('subtitle1 has fontSize 10 and yellow color', () {
      const style = PinballTextStyle.subtitle1;
      expect(style.fontSize, 10);
      expect(style.color, PinballColors.yellow);
    });

    test('subtitle2 has fontSize 16 and white color', () {
      const style = PinballTextStyle.subtitle2;
      expect(style.fontSize, 16);
      expect(style.color, PinballColors.white);
    });
  });
}
