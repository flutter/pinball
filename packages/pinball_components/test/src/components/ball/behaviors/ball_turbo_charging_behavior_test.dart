// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'BallTurboChargingBehavior',
    () {
      final assets = [
        theme.Assets.images.dash.ball.keyName,
        Assets.images.ball.flameEffect.keyName,
      ];
      final flameTester = FlameTester(() => TestGame(assets));

      test('can be instantiated', () {
        expect(
          BallTurboChargingBehavior(impulse: Vector2.zero()),
          isA<BallTurboChargingBehavior>(),
        );
      });

      flameTester.test('can be loaded', (game) async {
        final ball = Ball.test();
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
          final ball = Ball.test();
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
        final ball = Ball();
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
        final ball = Ball();
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
