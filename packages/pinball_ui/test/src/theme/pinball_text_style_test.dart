import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballTextStyle', () {
    test('displayLarge has fontSize 28 and white color', () {
      const style = PinballTextStyle.displayLarge;
      expect(style.fontSize, 28);
      expect(style.color, PinballColors.white);
    });

    test('displayMedium has fontSize 24', () {
      const style = PinballTextStyle.displayMedium;
      expect(style.fontSize, 24);
    });

    test('displaySmall has fontSize 20 and dark blue color', () {
      const style = PinballTextStyle.displaySmall;
      expect(style.fontSize, 20);
      expect(style.color, PinballColors.darkBlue);
    });

    test('headlineMedium has fontSize 16 and white color', () {
      const style = PinballTextStyle.headlineMedium;
      expect(style.fontSize, 16);
      expect(style.color, PinballColors.white);
    });

    test('headlineSmall has fontSize 14 and white color', () {
      const style = PinballTextStyle.headlineSmall;
      expect(style.fontSize, 14);
      expect(style.color, PinballColors.white);
    });

    test('titleMedium has fontSize 12 and yellow color', () {
      const style = PinballTextStyle.titleMedium;
      expect(style.fontSize, 12);
      expect(style.color, PinballColors.yellow);
    });
  });
}
