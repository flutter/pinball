import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ball', () {
    FlameTester(PinballGame.new).test(
      'loads correctly',
      (game) async {
        final ball = Ball(position: Vector2.zero());
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('body', () {
      FlameTester(PinballGame.new).test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ball = Ball(position: position);
          await game.ensureAdd(ball);
          game.contains(ball);

          expect(ball.body.position, position);
        },
      );

      FlameTester(PinballGame.new).test(
        'is dynamic',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );
    });

    group('first fixture', () {
      FlameTester(PinballGame.new).test(
        'exists',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      FlameTester(PinballGame.new).test(
        'is dense',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      FlameTester(PinballGame.new).test(
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
