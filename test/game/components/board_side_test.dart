import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group(
    'BoardSide',
    () {
      test('has two values', () {
        expect(BoardSide.values.length, equals(2));
      });
    },
  );

  group('BoardSideX', () {
    test('isLeft is correct', () {
      const side = BoardSide.left;
      expect(side.isLeft, isTrue);
      expect(side.isRight, isFalse);
    });

    test('isRight is correct', () {
      const side = BoardSide.right;
      expect(side.isLeft, isFalse);
      expect(side.isRight, isTrue);
    });
  });
}
