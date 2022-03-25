import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  group('ArcShape', () {
    test('can be instantiated', () {
      expect(
        ArcShape(
          center: Vector2.zero(),
          arcRadius: 10,
          angle: 2 * math.pi,
          rotation: 0,
        ),
        isNotNull,
      );
    });
  });

  group('copyWith', () {
    test('returns same shape when no properties are passed', () {
      final arcShape = ArcShape(
        center: Vector2.zero(),
        arcRadius: 10,
        angle: 2 * math.pi,
        rotation: 0,
      );
      final arcShapeCopied = arcShape.copyWith();

      for (var index = 0; index < arcShape.vertices.length; index++) {
        expect(
          arcShape.vertices[index],
          equals(arcShapeCopied.vertices[index]),
        );
      }
    });

    test('returns object with updated properties when are passed', () {
      final arcShapeExpected = ArcShape(
        center: Vector2.all(10),
        arcRadius: 10,
        angle: 2 * math.pi,
        rotation: 0,
      );
      final arcShapeCopied = ArcShape(
        center: Vector2.zero(),
        arcRadius: 10,
        angle: 2 * math.pi,
        rotation: 0,
      ).copyWith(center: Vector2.all(10));

      for (var index = 0; index < arcShapeCopied.vertices.length; index++) {
        expect(
          arcShapeCopied.vertices[index],
          equals(arcShapeExpected.vertices[index]),
        );
      }
    });
  });
}
