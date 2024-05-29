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

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final ball = Ball.test();
        final behavior = BallGravitatingBehavior();
        await ball.add(behavior);
        await game.ensureAdd(ball);
      },
      verify: (game, _) async {
        final ball = game.descendants().whereType<Ball>().single;
        expect(
          ball.firstChild<BallGravitatingBehavior>(),
          isNotNull,
        );
      },
    );

    flameTester.testGameWidget(
      "overrides the body's horizontal gravity symmetrically",
      setUp: (game, _) async {
        final ball1 = Ball.test()..initialPosition = Vector2(10, 0);
        await ball1.add(BallGravitatingBehavior());

        final ball2 = Ball.test()..initialPosition = Vector2(-10, 0);
        await ball2.add(BallGravitatingBehavior());

        await game.ensureAddAll([ball1, ball2]);
      },
      verify: (game, _) async {
        final balls = game.descendants().whereType<Ball>().toList();
        game.update(1);

        expect(
          balls[0].body.gravityOverride!.x,
          equals(-balls[1].body.gravityOverride!.x),
        );
        expect(
          balls[0].body.gravityOverride!.y,
          equals(balls[1].body.gravityOverride!.y),
        );
      },
    );
  });
}
