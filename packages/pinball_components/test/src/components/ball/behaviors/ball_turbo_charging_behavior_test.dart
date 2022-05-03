// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'BallTurboChargingBehavior',
    () {
      final assets = [Assets.images.ball.ball.keyName];
      final flameTester = FlameTester(() => TestGame(assets));
      const baseColor = Color(0xFFFFFFFF);

      test('can be instantiated', () {
        expect(
          BallTurboChargingBehavior(impulse: Vector2.zero()),
          isA<BallTurboChargingBehavior>(),
        );
      });

      flameTester.test('can be loaded', (game) async {
        final ball = Ball.test(baseColor: baseColor);
        final behavior = BallTurboChargingBehavior(impulse: Vector2.zero());
        await ball.add(behavior);
        await game.ensureAdd(ball);
        expect(
          ball.firstChild<BallTurboChargingBehavior>(),
          equals(behavior),
        );
      });

      flameTester.test(
        'impulses the ball velocity when loaded',
        (game) async {
          final ball = Ball.test(baseColor: baseColor);
          await game.ensureAdd(ball);
          final impulse = Vector2.all(1);
          final behavior = BallTurboChargingBehavior(impulse: impulse);
          await ball.ensureAdd(behavior);

          expect(
            ball.body.linearVelocity.x,
            equals(impulse.x),
          );
          expect(
            ball.body.linearVelocity.y,
            equals(impulse.y),
          );
        },
      );

      flameTester.test('adds sprite', (game) async {
        final ball = Ball(baseColor: baseColor);
        await game.ensureAdd(ball);

        await ball.ensureAdd(
          BallTurboChargingBehavior(impulse: Vector2.zero()),
        );

        expect(
          ball.children.whereType<SpriteAnimationComponent>().single,
          isNotNull,
        );
      });

      flameTester.test('removes sprite after it finishes', (game) async {
        final ball = Ball(baseColor: baseColor);
        await game.ensureAdd(ball);

        final behavior = BallTurboChargingBehavior(impulse: Vector2.zero());
        await ball.ensureAdd(behavior);

        final turboChargeSpriteAnimation =
            ball.children.whereType<SpriteAnimationComponent>().single;

        expect(ball.contains(turboChargeSpriteAnimation), isTrue);

        game.update(behavior.timer.limit);
        game.update(0.1);

        expect(ball.contains(turboChargeSpriteAnimation), isFalse);
      });
    },
  );
}
