// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('SlingShot', () {
    final flameTester = FlameTester(Forge2DGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final slingShot = SlingShot(
          position: Vector2.zero(),
          side: BoardSide.left,
        );
        await game.ensureAdd(slingShot);

        expect(game.contains(slingShot), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final slingShot = SlingShot(
            position: position,
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          expect(slingShot.body.position, equals(position));
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          expect(slingShot.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          expect(slingShot.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is triangular',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          expect((fixture.shape as PolygonShape).vertices.length, equals(3));
        },
      );

      flameTester.test(
        'triangular shapes are different '
        'when side is left or right',
        (game) async {
          final leftSlingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          final rightSlingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.right,
          );

          await game.ensureAdd(leftSlingShot);
          await game.ensureAdd(rightSlingShot);

          final rightShape =
              rightSlingShot.body.fixtures[0].shape as PolygonShape;
          final leftShape =
              leftSlingShot.body.fixtures[0].shape as PolygonShape;

          expect(rightShape.vertices, isNot(equals(leftShape.vertices)));
        },
      );

      flameTester.test(
        'has no friction',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[0];
          expect(fixture.friction, equals(0));
        },
      );
    });

    group('second fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          expect(slingShot.body.fixtures[1], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is edge',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[1];
          expect(fixture.shape.shapeType, equals(ShapeType.edge));
        },
      );

      flameTester.test(
        'has restitution',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[1];
          expect(fixture.restitution, greaterThan(0));
        },
      );

      flameTester.test(
        'has no friction',
        (game) async {
          final slingShot = SlingShot(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(slingShot);

          final fixture = slingShot.body.fixtures[1];
          expect(fixture.friction, equals(0));
        },
      );
    });
  });
}
