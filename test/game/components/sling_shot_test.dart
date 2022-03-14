// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

class EmptyGame extends Forge2DGame {}

void main() {
  group('SlingShot', () {
    final flameTester = FlameTester(EmptyGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final slingShot = SlingShot(position: Vector2.zero());
        await game.ensureAdd(slingShot);

        expect(game.contains(slingShot), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final slingShot = SlingShot(position: position);
          await game.ensureAdd(slingShot);

          expect(slingShot.body.position, equals(position));
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          expect(slingShot.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          expect(slingShot.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is triangular',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          expect((fixture.shape as PolygonShape).vertices.length, equals(3));
        },
      );
    });

    group('second fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          expect(slingShot.body.fixtures[1], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is edge',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[1];
          expect(fixture.shape.shapeType, equals(ShapeType.edge));
        },
      );

      flameTester.test(
        'has restitution',
        (game) async {
          final slingShot = SlingShot(position: Vector2.zero());
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[1];
          expect(fixture.restitution, greaterThan(0));
        },
      );
    });
  });
}
