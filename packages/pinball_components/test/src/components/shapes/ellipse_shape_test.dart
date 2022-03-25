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

    group('copyWith', () {
      test('returns same shape when no properties are passed', () {
        final ellipseShape = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 10,
          minorRadius: 8,
        );
        final ellipseShapeCopied = ellipseShape.copyWith();

        for (var index = 0; index < ellipseShape.vertices.length; index++) {
          expect(
            ellipseShape.vertices[index],
            equals(ellipseShapeCopied.vertices[index]),
          );
        }
      });

      test('returns object with updated center when center is passed', () {
        final ellipseShapeExpected = EllipseShape(
          center: Vector2.all(10),
          majorRadius: 10,
          minorRadius: 8,
        );
        final ellipseShapeCopied = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 10,
          minorRadius: 8,
        ).copyWith(center: Vector2.all(10));

        for (var index = 0;
            index < ellipseShapeCopied.vertices.length;
            index++) {
          expect(
            ellipseShapeCopied.vertices[index],
            equals(ellipseShapeExpected.vertices[index]),
          );
        }
      });

      test('returns object with updated majorRadius when majorRadius is passed',
          () {
        final ellipseShapeExpected = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 12,
          minorRadius: 8,
        );
        final ellipseShapeCopied = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 10,
          minorRadius: 8,
        ).copyWith(majorRadius: 12);

        for (var index = 0;
            index < ellipseShapeCopied.vertices.length;
            index++) {
          expect(
            ellipseShapeCopied.vertices[index],
            equals(ellipseShapeExpected.vertices[index]),
          );
        }
      });

      test('returns object with updated minorRadius when minorRadius is passed',
          () {
        final ellipseShapeExpected = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 12,
          minorRadius: 5,
        );
        final ellipseShapeCopied = EllipseShape(
          center: Vector2.zero(),
          majorRadius: 12,
          minorRadius: 8,
        ).copyWith(minorRadius: 5);

        for (var index = 0;
            index < ellipseShapeCopied.vertices.length;
            index++) {
          expect(
            ellipseShapeCopied.vertices[index],
            equals(ellipseShapeExpected.vertices[index]),
          );
        }
      });
    });
  });
}
