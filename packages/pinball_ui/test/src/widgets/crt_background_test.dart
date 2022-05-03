import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('CrtBackground', () {
    test('is a BoxDecoration with a LinearGradient', () {
      // ignore: prefer_const_constructors
      final crtBg = CrtBackground();
      const expectedGradient = LinearGradient(
        begin: Alignment(1, 0.015),
        stops: [0.0, 0.5, 0.5, 1],
        colors: [
          PinballColors.darkBlue,
          PinballColors.darkBlue,
          PinballColors.crtBackground,
          PinballColors.crtBackground,
        ],
        tileMode: TileMode.repeated,
      );
      expect(crtBg, isA<BoxDecoration>());
      expect(crtBg.gradient, expectedGradient);
    });
  });
}
