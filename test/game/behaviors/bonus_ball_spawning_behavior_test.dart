// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      theme.Assets.images.dash.ball.keyName,
    ]);
  }

  Future<void> pump(BonusBallSpawningBehavior child) async {
    await ensureAdd(
      FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
        value: CharacterThemeCubit(),
        children: [
          ZCanvasComponent(
            children: [child],
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterForestBonusBehavior', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds a ball with a BallImpulsingBehavior to the game onTick '
      'resulting in a -40 x impulse',
      setUp: (game, _) async {
        await game.onLoad();
        final behavior = BonusBallSpawningBehavior();

        await game.pump(behavior);
        await game.ready();
      },
      verify: (game, tester) async {
        expect(
          game.descendants().whereType<BonusBallSpawningBehavior>(),
          isNotEmpty,
        );
        final behavior =
            game.descendants().whereType<BonusBallSpawningBehavior>().single;
        game.update(behavior.timer.limit);
        await tester.pump();

        expect(game.descendants().whereType<Ball>(), isNotEmpty);
        final ball = game.descendants().whereType<Ball>().single;

        expect(ball.body.linearVelocity.x, equals(-40));
        expect(ball.body.linearVelocity.y, equals(0));
      },
    );
  });
}
