// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ball', () {
    final flameTester = FlameTester(PinballGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = Ball(position: Vector2.zero());
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ball = Ball(position: position);
          await game.ensureAdd(ball);
          game.contains(ball);

          expect(ball.body.position, position);
        },
      );

      flameTester.test(
        'is dynamic',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is dense',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2));
        },
      );
    });
  });
}
