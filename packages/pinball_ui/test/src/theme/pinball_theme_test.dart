import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballTheme', () {
    group('standard', () {
      test('displayLarge matches PinballTextStyle#displayLarge', () {
        expect(
          PinballTheme.standard.textTheme.displayLarge!.fontSize,
          PinballTextStyle.displayLarge.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displayLarge!.color,
          PinballTextStyle.displayLarge.color,
        );
        expect(
          PinballTheme.standard.textTheme.displayLarge!.fontFamily,
          PinballTextStyle.displayLarge.fontFamily,
        );
      });

      test('displayMedium matches PinballTextStyle#displayMedium', () {
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontSize,
          PinballTextStyle.displayMedium.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontFamily,
          PinballTextStyle.displayMedium.fontFamily,
        );
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontWeight,
          PinballTextStyle.displayMedium.fontWeight,
        );
      });

      test('displaySmall matches PinballTextStyle#displaySmall', () {
        expect(
          PinballTheme.standard.textTheme.displaySmall!.fontSize,
          PinballTextStyle.displaySmall.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displaySmall!.color,
          PinballTextStyle.displaySmall.color,
        );
        expect(
          PinballTheme.standard.textTheme.displaySmall!.fontFamily,
          PinballTextStyle.displaySmall.fontFamily,
        );
      });

      test('headlineMedium matches PinballTextStyle#headlineMedium', () {
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.fontSize,
          PinballTextStyle.headlineMedium.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.color,
          PinballTextStyle.headlineMedium.color,
        );
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.fontFamily,
          PinballTextStyle.headlineMedium.fontFamily,
        );
      });

      test('titleMedium matches PinballTextStyle#titleMedium', () {
        expect(
          PinballTheme.standard.textTheme.titleMedium!.fontSize,
          PinballTextStyle.titleMedium.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.titleMedium!.color,
          PinballTextStyle.titleMedium.color,
        );
        expect(
          PinballTheme.standard.textTheme.titleMedium!.fontFamily,
          PinballTextStyle.titleMedium.fontFamily,
        );
      });
    });
  });
}
