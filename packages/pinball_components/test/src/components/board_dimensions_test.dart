import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('BoardDimensions', () {
    test('has size', () {
      expect(BoardDimensions.size, equals(Vector2(101.6, 143.8)));
    });

    test('has bounds', () {
      expect(BoardDimensions.bounds, isNotNull);
    });

    test('has perspectiveAngle', () {
      expect(BoardDimensions.perspectiveAngle, isNotNull);
    });

    test('has perspectiveShrinkFactor', () {
      expect(BoardDimensions.perspectiveShrinkFactor, equals(0.63));
    });

    test('has shrinkAdjustedHeight', () {
      expect(BoardDimensions.shrinkAdjustedHeight, isNotNull);
    });
  });
}
