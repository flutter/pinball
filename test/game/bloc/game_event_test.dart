import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('GameEvent', () {
    group('BallLost', () {
      test('can be instantiated', () {
        expect(const BallLost(), isNotNull);
      });
    });

    group('Scored', () {
      test('can be instantiated', () {
        expect(const Scored(points: 1), isNotNull);
      });

      test(
          'throws AssertionError '
          'when score is smaller than 1', () {
        expect(() => Scored(points: 0), throwsAssertionError);
      });
    });
  });
}
