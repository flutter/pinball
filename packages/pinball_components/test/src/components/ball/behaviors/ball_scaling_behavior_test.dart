// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(
    () => TestGame([theme.Assets.images.dash.ball.keyName]),
  );

  group('BallScalingBehavior', () {
    test('can be instantiated', () {
      expect(
        BallScalingBehavior(),
        isA<BallScalingBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final ball = Ball.test();
        final behavior = BallScalingBehavior();
        await ball.add(behavior);
        await game.ensureAdd(ball);
      },
      verify: (game, _) async {
        final ball = game.descendants().whereType<Ball>().single;
        expect(
          ball.firstChild<BallScalingBehavior>(),
          isNotNull,
        );
      },
    );

    flameTester.testGameWidget(
      'scales the shape radius',
      setUp: (game, _) async {
        final ball1 = Ball.test()..initialPosition = Vector2(0, 10);
        await ball1.add(BallScalingBehavior());

        final ball2 = Ball.test()..initialPosition = Vector2(0, -10);
        await ball2.add(BallScalingBehavior());

        await game.ensureAddAll([ball1, ball2]);
      },
      verify: (game, _) async {
        final balls = game.descendants().whereType<Ball>().toList();
        game.update(1);

        final shape1 = balls[0].body.fixtures.first.shape;
        final shape2 = balls[1].body.fixtures.first.shape;
        expect(
          shape1.radius,
          greaterThan(shape2.radius),
        );
      },
    );

    flameTester.testGameWidget(
      'scales the sprite',
      setUp: (game, _) async {
        final ball1 = Ball.test()..initialPosition = Vector2(0, 10);
        await ball1.add(BallScalingBehavior());

        final ball2 = Ball.test()..initialPosition = Vector2(0, -10);
        await ball2.add(BallScalingBehavior());

        await game.ensureAddAll([ball1, ball2]);
      },
      verify: (game, _) async {
        final balls = game.descendants().whereType<Ball>().toList();
        game.update(1);

        final sprite1 =
            balls[0].descendants().whereType<SpriteComponent>().single;
        final sprite2 =
            balls[1].descendants().whereType<SpriteComponent>().single;
        expect(
          sprite1.scale.x,
          greaterThan(sprite2.scale.x),
        );
        expect(
          sprite1.scale.y,
          greaterThan(sprite2.scale.y),
        );
      },
    );
  });
}
