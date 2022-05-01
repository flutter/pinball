import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballColors', () {
    test('white is 0xFFFFFFFF', () {
      expect(PinballColors.white, const Color(0xFFFFFFFF));
    });

    test('darkBlue is 0xFF0C32A4', () {
      expect(PinballColors.darkBlue, const Color(0xFF0C32A4));
    });

    test('yellow is 0xFFFFEE02', () {
      expect(PinballColors.yellow, const Color(0xFFFFEE02));
    });

    test('orange is 0xFFE5AB05', () {
      expect(PinballColors.orange, const Color(0xFFE5AB05));
    });

    test('blue is 0xFF4B94F6', () {
      expect(PinballColors.blue, const Color(0xFF4B94F6));
    });

    test('transparent is 0x00000000', () {
      expect(PinballColors.transparent, const Color(0x00000000));
    });
  });
}
