import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  group('EllipseShape', () {
    group('rotate', () {
      test('returns vertices rotated', () {
        const rotationAngle = 2 * math.pi;
        final ellipseShape = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 10,
          minorRadius: 8,
        );
        final ellipseShapeRotated = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 10,
          minorRadius: 8,
        )..rotate(rotationAngle);

        for (var index = 0; index < ellipseShape.vertices.length; index++) {
          expect(
            ellipseShape.vertices[index]..rotate(rotationAngle),
            equals(ellipseShapeRotated.vertices[index]),
          );
        }
      });
    });
  });
}
