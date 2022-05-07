import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballTheme', () {
    group('standard', () {
      test('headline1 matches PinballTextStyle#headline1', () {
        expect(
          PinballTheme.standard.textTheme.headline1!.fontSize,
          PinballTextStyle.headline1.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headline1!.color,
          PinballTextStyle.headline1.color,
        );
        expect(
          PinballTheme.standard.textTheme.headline1!.fontFamily,
          PinballTextStyle.headline1.fontFamily,
        );
      });

      test('headline2 matches PinballTextStyle#headline2', () {
        expect(
          PinballTheme.standard.textTheme.headline2!.fontSize,
          PinballTextStyle.headline2.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headline2!.fontFamily,
          PinballTextStyle.headline2.fontFamily,
        );
        expect(
          PinballTheme.standard.textTheme.headline2!.fontWeight,
          PinballTextStyle.headline2.fontWeight,
        );
      });

      test('headline3 matches PinballTextStyle#headline3', () {
        expect(
          PinballTheme.standard.textTheme.headline3!.fontSize,
          PinballTextStyle.headline3.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headline3!.color,
          PinballTextStyle.headline3.color,
        );
        expect(
          PinballTheme.standard.textTheme.headline3!.fontFamily,
          PinballTextStyle.headline3.fontFamily,
        );
      });

      test('headline4 matches PinballTextStyle#headline4', () {
        expect(
          PinballTheme.standard.textTheme.headline4!.fontSize,
          PinballTextStyle.headline4.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headline4!.color,
          PinballTextStyle.headline4.color,
        );
        expect(
          PinballTheme.standard.textTheme.headline4!.fontFamily,
          PinballTextStyle.headline4.fontFamily,
        );
      });

      test('subtitle1 matches PinballTextStyle#subtitle1', () {
        expect(
          PinballTheme.standard.textTheme.subtitle1!.fontSize,
          PinballTextStyle.subtitle1.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.subtitle1!.color,
          PinballTextStyle.subtitle1.color,
        );
        expect(
          PinballTheme.standard.textTheme.subtitle1!.fontFamily,
          PinballTextStyle.subtitle1.fontFamily,
        );
      });
    });
  });
}
