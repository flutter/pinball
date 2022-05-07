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
    'BallImpulsingBehavior',
    () {
      final asset = theme.Assets.images.dash.ball.keyName;
      final flameTester = FlameTester(() => TestGame([asset]));

      test('can be instantiated', () {
        expect(
          BallImpulsingBehavior(impulse: Vector2.zero()),
          isA<BallImpulsingBehavior>(),
        );
      });

      flameTester.test('can be loaded', (game) async {
        final ball = Ball.test();
        final behavior = BallImpulsingBehavior(impulse: Vector2.zero());
        await ball.add(behavior);
        await game.ensureAdd(ball);
        expect(
          ball.firstChild<BallImpulsingBehavior>(),
          equals(behavior),
        );
      });

      flameTester.test(
        'impulses the ball with the given velocity when loaded',
        (game) async {
          final ball = Ball.test();
          await game.ensureAdd(ball);
          final impulse = Vector2.all(1);
          final behavior = BallImpulsingBehavior(impulse: impulse);
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
    },
  );
}
