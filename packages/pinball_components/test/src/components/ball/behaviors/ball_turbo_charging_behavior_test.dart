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

      flameTester.testGameWidget(
        'can be loaded',
        setUp: (game, _) async {
          final ball = Ball.test();
          final behavior = BallTurboChargingBehavior(impulse: Vector2.zero());
          await ball.add(behavior);
          await game.ensureAdd(ball);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(
            ball.firstChild<BallTurboChargingBehavior>(),
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'impulses the ball velocity when loaded',
        setUp: (game, _) async {
          await game.onLoad();
          final ball = Ball.test();
          await game.ensureAdd(ball);
          final impulse = Vector2.all(1);
          final behavior = BallTurboChargingBehavior(impulse: impulse);
          await ball.ensureAdd(behavior);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(
            ball.body.linearVelocity.x,
            equals(1),
          );
          expect(
            ball.body.linearVelocity.y,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'adds sprite',
        setUp: (game, _) async {
          await game.onLoad();
          final ball = Ball();
          await game.ensureAdd(ball);
          await ball.ensureAdd(
            BallTurboChargingBehavior(impulse: Vector2.zero()),
          );
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          expect(
            ball.children.whereType<SpriteAnimationComponent>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'removes sprite after it finishes',
        setUp: (game, _) async {
          await game.onLoad();
          final ball = Ball();
          await game.ensureAdd(ball);

          final behavior = BallTurboChargingBehavior(impulse: Vector2.zero());
          await ball.ensureAdd(behavior);
        },
        verify: (game, _) async {
          final ball = game.descendants().whereType<Ball>().single;
          final turboChargeSpriteAnimation =
              ball.children.whereType<SpriteAnimationComponent>().single;
          final behavior =
              game.descendants().whereType<BallTurboChargingBehavior>().single;
          expect(ball.contains(turboChargeSpriteAnimation), isTrue);

          game.update(behavior.timer.limit);
          game.update(0.1);

          expect(ball.contains(turboChargeSpriteAnimation), isFalse);
        },
      );
    },
  );
}
