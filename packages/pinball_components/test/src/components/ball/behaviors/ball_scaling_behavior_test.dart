// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final asset = theme.Assets.images.dash.ball.keyName;
  final flameTester = FlameTester(() => TestGame([asset]));

  group('BallScalingBehavior', () {
    test('can be instantiated', () {
      expect(
        BallScalingBehavior(),
        isA<BallScalingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final ball = Ball.test();
      final behavior = BallScalingBehavior();
      await ball.add(behavior);
      await game.ensureAdd(ball);
      expect(
        ball.firstChild<BallScalingBehavior>(),
        equals(behavior),
      );
    });

    flameTester.test('scales the shape radius', (game) async {
      final ball1 = Ball.test()..initialPosition = Vector2(0, 10);
      await ball1.add(BallScalingBehavior());

      final ball2 = Ball.test()..initialPosition = Vector2(0, -10);
      await ball2.add(BallScalingBehavior());

      await game.ensureAddAll([ball1, ball2]);
      game.update(1);

      final shape1 = ball1.body.fixtures.first.shape;
      final shape2 = ball2.body.fixtures.first.shape;
      expect(
        shape1.radius,
        greaterThan(shape2.radius),
      );
    });

    flameTester.test(
      'scales the sprite',
      (game) async {
        final ball1 = Ball.test()..initialPosition = Vector2(0, 10);
        await ball1.add(BallScalingBehavior());

        final ball2 = Ball.test()..initialPosition = Vector2(0, -10);
        await ball2.add(BallScalingBehavior());

        await game.ensureAddAll([ball1, ball2]);
        game.update(1);

        final sprite1 = ball1.descendants().whereType<SpriteComponent>().single;
        final sprite2 = ball2.descendants().whereType<SpriteComponent>().single;
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
