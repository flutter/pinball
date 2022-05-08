import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

void main() {
  group('BezierCurveShape', () {
    late List<Vector2> controlPoints;

    setUp(() {
      controlPoints = [
        Vector2(0, 0),
        Vector2(10, 0),
        Vector2(0, 10),
        Vector2(10, 10),
      ];
    });

    test('can be instantiated', () {
      expect(
        BezierCurveShape(
          controlPoints: controlPoints,
        ),
        isA<BezierCurveShape>,
      );
    });
  });
}
