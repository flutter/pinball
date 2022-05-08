import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

void main() {
  group('ArcShape', () {
    test('can be instantiated', () {
      expect(
        ArcShape(
          center: Vector2.zero(),
          arcRadius: 10,
          angle: 2 * math.pi,
        ),
        isA<ArcShape>(),
      );
    });
  });
}
