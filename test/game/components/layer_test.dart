// ignore_for_file: cascade_invocations
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('Layer', () {
    test('has four values', () {
      expect(Layer.values.length, equals(5));
    });
  });

  group('LayerX', () {
    test('all types are different', () {
      expect(Layer.all.maskBits, isNot(equals(Layer.board.maskBits)));
      expect(Layer.board.maskBits, isNot(equals(Layer.opening.maskBits)));
      expect(Layer.opening.maskBits, isNot(equals(Layer.jetpack.maskBits)));
      expect(Layer.jetpack.maskBits, isNot(equals(Layer.launcher.maskBits)));
      expect(Layer.launcher.maskBits, isNot(equals(Layer.board.maskBits)));
    });

    test('all type has 0xFFFF maskBits', () {
      expect(Layer.all.maskBits, equals(0xFFFF));
    });
    test('board type has 0x0001 maskBits', () {
      expect(Layer.board.maskBits, equals(0x0001));
    });

    test('opening type has 0x0007 maskBits', () {
      expect(Layer.opening.maskBits, equals(0x0007));
    });

    test('jetpack type has 0x0002 maskBits', () {
      expect(Layer.jetpack.maskBits, equals(0x0002));
    });

    test('launcher type has 0x0005 maskBits', () {
      expect(Layer.launcher.maskBits, equals(0x0005));
    });
  });
}
