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

  group('BallGravitatingBehavior', () {
    test('can be instantiated', () {
      expect(
        BallGravitatingBehavior(),
        isA<BallGravitatingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final ball = Ball.test();
      final behavior = BallGravitatingBehavior();
      await ball.add(behavior);
      await game.ensureAdd(ball);
      expect(
        ball.firstChild<BallGravitatingBehavior>(),
        equals(behavior),
      );
    });

    flameTester.test(
      "overrides the body's horizontal gravity symmetrically",
      (game) async {
        final ball1 = Ball.test()..initialPosition = Vector2(10, 0);
        await ball1.add(BallGravitatingBehavior());

        final ball2 = Ball.test()..initialPosition = Vector2(-10, 0);
        await ball2.add(BallGravitatingBehavior());

        await game.ensureAddAll([ball1, ball2]);
        game.update(1);

        expect(
          ball1.body.gravityOverride!.x,
          equals(-ball2.body.gravityOverride!.x),
        );
        expect(
          ball1.body.gravityOverride!.y,
          equals(ball2.body.gravityOverride!.y),
        );
      },
    );
  });
}
