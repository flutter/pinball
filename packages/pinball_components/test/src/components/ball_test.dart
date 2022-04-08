// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('Ball', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = Ball(baseColor: Colors.blue);
        await game.ready();
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is dynamic',
        (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );

      group('can be moved', () {
        flameTester.test('by its weight', (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          game.update(1);
          expect(ball.body.position, isNot(equals(ball.initialPosition)));
        });

        flameTester.test('by applying velocity', (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          ball.body.gravityScale = 0;
          ball.body.linearVelocity.setValues(10, 10);
          game.update(1);
          expect(ball.body.position, isNot(equals(ball.initialPosition)));
        });
      });
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is dense',
        (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2.065));
        },
      );

      flameTester.test(
        'has Layer.all as default filter maskBits',
        (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ready();
          await game.ensureAdd(ball);
          await game.ready();

          final fixture = ball.body.fixtures[0];
          expect(fixture.filterData.maskBits, equals(Layer.board.maskBits));
        },
      );
    });

    group('stop', () {
      group("can't be moved", () {
        flameTester.test('by its weight', (game) async {
          final ball = Ball(baseColor: Colors.blue);
          await game.ensureAdd(ball);
          ball.stop();

          game.update(1);
          expect(ball.body.position, equals(ball.initialPosition));
        });
      });

      flameTester.test('by applying velocity', (game) async {
        final ball = Ball(baseColor: Colors.blue);
        await game.ensureAdd(ball);
        ball.stop();

        ball.body.linearVelocity.setValues(10, 10);
        game.update(1);
        expect(ball.body.position, equals(ball.initialPosition));
      });
    });

    group('resume', () {
      group('can move', () {
        flameTester.test(
          'by its weight when previously stopped',
          (game) async {
            final ball = Ball(baseColor: Colors.blue);
            await game.ensureAdd(ball);
            ball.stop();
            ball.resume();

            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );

        flameTester.test(
          'by applying velocity when previously stopped',
          (game) async {
            final ball = Ball(baseColor: Colors.blue);
            await game.ensureAdd(ball);
            ball.stop();
            ball.resume();

            ball.body.gravityScale = 0;
            ball.body.linearVelocity.setValues(10, 10);
            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );
      });
    });

    group('boost', () {
      flameTester.test('applies an impulse to the ball', (game) async {
        final ball = Ball(baseColor: Colors.blue);
        await game.ensureAdd(ball);

        expect(ball.body.linearVelocity, equals(Vector2.zero()));

        ball.boost(Vector2.all(10));
        expect(ball.body.linearVelocity.x, greaterThan(0));
        expect(ball.body.linearVelocity.y, greaterThan(0));
      });

      flameTester.test('adds fire effect components to the game', (game) async {
        final ball = Ball(baseColor: Colors.blue);
        await game.ensureAdd(ball);

        ball.boost(Vector2.all(10));
        game.update(0);
        await game.ready();

        expect(game.children.whereType<FireEffect>().length, greaterThan(0));
      });
    });
  });
}
