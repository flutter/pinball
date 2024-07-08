// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    theme.Assets.images.android.ball.keyName,
    theme.Assets.images.dash.ball.keyName,
    theme.Assets.images.dino.ball.keyName,
    theme.Assets.images.sparky.ball.keyName,
  ];

  final flameTester = FlameTester(() => TestGame(assets));

  group('Ball', () {
    test(
      'can be instantiated',
      () {
        expect(Ball(), isA<Ball>());
        expect(Ball.test(), isA<Ball>());
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final ball = Ball();
        await game.ensureAdd(ball);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Ball>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'has only one SpriteComponent',
      setUp: (game, _) async {
        await game.onLoad();
        final ball = Ball();
        await game.ensureAdd(ball);
        await game.ready();
      },
      verify: (game, _) async {
        final ball = game.descendants().whereType<Ball>().single;
        expect(
          ball.descendants().whereType<SpriteComponent>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'BallSpriteComponent changes sprite onNewState',
      setUp: (game, _) async {
        await game.onLoad();
        final ball = Ball();
        await game.ensureAdd(ball);
        await game.ready();
      },
      verify: (game, _) async {
        final ball = game.descendants().whereType<Ball>().single;
        final ballSprite =
            ball.descendants().whereType<BallSpriteComponent>().single;
        final originalSprite = ballSprite.sprite;

        ballSprite.onNewState(
          const BallState(characterTheme: theme.DinoTheme()),
        );
        game.update(0);

        final newSprite = ballSprite.sprite;
        expect(newSprite != originalSprite, isTrue);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'a BallScalingBehavior',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(
            ball.descendants().whereType<BallScalingBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a BallGravitatingBehavior',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(
            ball.descendants().whereType<BallGravitatingBehavior>().length,
            equals(1),
          );
        },
      );
    });

    group('body', () {
      flameTester.testGameWidget(
        'is dynamic',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );

      group('can be moved', () {
        flameTester.testGameWidget(
          'by its weight',
          setUp: (game, _) async {
            final ball = Ball();
            await game.ensureAdd(ball);
          },
          verify: (game, _) async {
            final ball = game.descendants().whereType<Ball>().single;

            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );

        flameTester.testGameWidget(
          'by applying velocity',
          setUp: (game, _) async {
            final ball = Ball();
            await game.ensureAdd(ball);
          },
          verify: (game, _) async {
            final ball = game.descendants().whereType<Ball>().single;

            ball.body.gravityScale = Vector2.zero();
            ball.body.linearVelocity.setValues(10, 10);
            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );
      });
    });

    group('fixture', () {
      flameTester.testGameWidget(
        'exists',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.testGameWidget(
        'is dense',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.testGameWidget(
        'shape is circular',
        setUp: (game, _) async {
          final ball = Ball.test();
          await game.world.ensureAdd(ball);
          await game.ready();
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2.065));
        },
      );

      flameTester.testGameWidget(
        'has Layer.all as default filter maskBits',
        setUp: (game, _) async {
          final ball = Ball();
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;

          final fixture = ball.body.fixtures[0];
          expect(fixture.filterData.maskBits, equals(Layer.board.maskBits));
        },
      );
    });

    group('stop', () {
      group("can't be moved", () {
        flameTester.testGameWidget(
          'by its weight',
          setUp: (game, _) async {
            final ball = Ball();
            await game.ensureAdd(ball);
          },
          verify: (game, _) async {
            final ball = game.descendants().whereType<Ball>().single;
            ball.stop();

            game.update(1);
            expect(ball.body.position, equals(ball.initialPosition));
          },
        );
      });
    });

    group('resume', () {
      group('can move', () {
        flameTester.testGameWidget(
          'by its weight when previously stopped',
          setUp: (game, _) async {
            final ball = Ball();
            await game.ensureAdd(ball);
          },
          verify: (game, _) async {
            final ball = game.descendants().whereType<Ball>().single;
            ball.stop();
            ball.resume();

            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );

        flameTester.testGameWidget(
          'by applying velocity when previously stopped',
          setUp: (game, _) async {
            final ball = Ball();
            await game.ensureAdd(ball);
          },
          verify: (game, _) async {
            final ball = game.descendants().whereType<Ball>().single;
            ball.stop();
            ball.resume();

            ball.body.gravityScale = Vector2.zero();
            ball.body.linearVelocity.setValues(10, 10);
            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );
      });
    });
  });
}
