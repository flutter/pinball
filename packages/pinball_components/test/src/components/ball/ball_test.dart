// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/ball/behaviors/behaviors.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.ball.flameEffect.keyName,
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

    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = Ball();
        await game.ready();
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'android theme',
        setUp: (game, tester) async {
          final ball = Ball(
            spriteAsset: theme.Assets.images.android.ball.keyName,
          )..initialPosition = Vector2.zero();
          await game.ready();
          await game.ensureAdd(ball);

          await tester.pump();

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/ball/android.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'dash theme',
        setUp: (game, tester) async {
          final ball = Ball(
            spriteAsset: theme.Assets.images.dash.ball.keyName,
          )..initialPosition = Vector2.zero();
          await game.ready();
          await game.ensureAdd(ball);

          await tester.pump();

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/ball/dash.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'dino theme',
        setUp: (game, tester) async {
          final ball = Ball(
            spriteAsset: theme.Assets.images.dino.ball.keyName,
          )..initialPosition = Vector2.zero();
          await game.ready();
          await game.ensureAdd(ball);

          await tester.pump();

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/ball/dino.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'sparky theme',
        setUp: (game, tester) async {
          final ball = Ball(
            spriteAsset: theme.Assets.images.sparky.ball.keyName,
          )..initialPosition = Vector2.zero();
          await game.ready();
          await game.ensureAdd(ball);

          await tester.pump();

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/ball/sparky.png'),
          );
        },
      );
    });

    group('adds', () {
      flameTester.test('a BallScalingBehavior', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        expect(
          ball.descendants().whereType<BallScalingBehavior>().length,
          equals(1),
        );
      });

      flameTester.test('a BallGravitatingBehavior', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        expect(
          ball.descendants().whereType<BallGravitatingBehavior>().length,
          equals(1),
        );
      });
    });

    group('body', () {
      flameTester.test(
        'is dynamic',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );

      group('can be moved', () {
        flameTester.test('by its weight', (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          game.update(1);
          expect(ball.body.position, isNot(equals(ball.initialPosition)));
        });

        flameTester.test('by applying velocity', (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          ball.body.gravityScale = Vector2.zero();
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
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is dense',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2.065));
        },
      );

      flameTester.test(
        'has Layer.all as default filter maskBits',
        (game) async {
          final ball = Ball();
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
          final ball = Ball();
          await game.ensureAdd(ball);
          ball.stop();

          game.update(1);
          expect(ball.body.position, equals(ball.initialPosition));
        });
      });
    });

    group('resume', () {
      group('can move', () {
        flameTester.test(
          'by its weight when previously stopped',
          (game) async {
            final ball = Ball();
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
            final ball = Ball();
            await game.ensureAdd(ball);
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

    group('boost', () {
      flameTester.test('applies an impulse to the ball', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);

        expect(ball.body.linearVelocity, equals(Vector2.zero()));

        await ball.boost(Vector2.all(10));
        expect(ball.body.linearVelocity.x, greaterThan(0));
        expect(ball.body.linearVelocity.y, greaterThan(0));
      });

      flameTester.test('adds TurboChargeSpriteAnimation', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);

        await ball.boost(Vector2.all(10));
        game.update(0);

        expect(
          ball.children.whereType<SpriteAnimationComponent>().single,
          isNotNull,
        );
      });

      flameTester.test('removes TurboChargeSpriteAnimation after it finishes',
          (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);

        await ball.boost(Vector2.all(10));
        game.update(0);

        final turboChargeSpriteAnimation =
            ball.children.whereType<SpriteAnimationComponent>().single;

        expect(ball.contains(turboChargeSpriteAnimation), isTrue);

        game.update(turboChargeSpriteAnimation.animation!.totalDuration());
        game.update(0.1);

        expect(ball.contains(turboChargeSpriteAnimation), isFalse);
      });
    });
  });
}
