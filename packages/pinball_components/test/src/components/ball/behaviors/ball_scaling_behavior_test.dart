// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/ball/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final asset = Assets.images.ball.ball.keyName;
  final flameTester = FlameTester(() => TestGame([asset]));

  group('BallScalingBehavior', () {
    const baseColor = Color(0xFFFFFFFF);
    test('can be instantiated', () {
      expect(
        BallScalingBehavior(),
        isA<BallScalingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final ball = Ball.test(baseColor: baseColor);
      final behavior = BallScalingBehavior();
      await ball.add(behavior);
      await game.ensureAdd(ball);
      expect(
        ball.firstChild<BallScalingBehavior>(),
        equals(behavior),
      );
    });

    flameTester.test('scales the shape radius', (game) async {
      final ball1 = Ball.test(baseColor: baseColor)
        ..initialPosition = Vector2(0, 10);
      await ball1.add(BallScalingBehavior());

      final ball2 = Ball.test(baseColor: baseColor)
        ..initialPosition = Vector2(0, -10);
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

    flameTester.testGameWidget(
      'scales the sprite',
      setUp: (game, tester) async {
        final ball1 = Ball.test(baseColor: baseColor)
          ..initialPosition = Vector2(0, 10);
        await ball1.add(BallScalingBehavior());

        final ball2 = Ball.test(baseColor: baseColor)
          ..initialPosition = Vector2(0, -10);
        await ball2.add(BallScalingBehavior());

        await game.ensureAddAll([ball1, ball2]);
        game.update(1);

        await tester.pump();
        await game.ready();

        final sprite1 = ball1.firstChild<SpriteComponent>()!;
        final sprite2 = ball2.firstChild<SpriteComponent>()!;
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
