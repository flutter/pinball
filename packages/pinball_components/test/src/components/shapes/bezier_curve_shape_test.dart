import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  group('BezierCurveShape', () {
    final controlPoints = [
      Vector2(0, 0),
      Vector2(10, 0),
      Vector2(0, 10),
      Vector2(10, 10),
    ];

    test('can be instantiated', () {
      expect(
        BezierCurveShape(
          controlPoints: controlPoints,
        ),
        isNotNull,
      );
    });

    group('rotate', () {
      test('returns vertices rotated', () {
        const rotationAngle = 2 * math.pi;
        final controlPoints = [
          Vector2(0, 0),
          Vector2(10, 0),
          Vector2(0, 10),
          Vector2(10, 10),
        ];

        final bezierCurveShape = BezierCurveShape(
          controlPoints: controlPoints,
        );
        final bezierCurveShapeRotated = BezierCurveShape(
          controlPoints: controlPoints,
        )..rotate(rotationAngle);

        for (var index = 0; index < bezierCurveShape.vertices.length; index++) {
          expect(
            bezierCurveShape.vertices[index]..rotate(rotationAngle),
            equals(bezierCurveShapeRotated.vertices[index]),
          );
        }
      });
    });
  });
}
