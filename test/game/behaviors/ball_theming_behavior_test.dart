// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
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
      theme.Assets.images.dino.ball.keyName,
    ]);
  }

  Future<void> pump(
    List<Component> children, {
    CharacterThemeCubit? characterThemeBloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
        value: characterThemeBloc ?? CharacterThemeCubit(),
        children: children,
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'BallThemingBehavior',
    () {
      final flameTester = FlameTester(_TestGame.new);

      test('can be instantiated', () {
        expect(
          BallThemingBehavior(),
          isA<BallThemingBehavior>(),
        );
      });

      flameTester.test(
        'loads',
        (game) async {
          final behavior = BallThemingBehavior();
          await game.pump([behavior]);
          expect(game.descendants(), contains(behavior));
        },
      );

      flameTester.test(
        'onNewState replaces the current ball with a new ball',
        (game) async {
          final behavior = BallThemingBehavior();
          await game.pump([
            behavior,
            ZCanvasComponent(),
            Plunger.test(compressionDistance: 10),
            Ball(),
          ]);
          expect(game.descendants().whereType<Ball>(), isNotEmpty);
          final dashBall = game.descendants().whereType<Ball>().single;

          const dinoTheme = CharacterThemeState(theme.DinoTheme());
          behavior.onNewState(dinoTheme);
          await game.ready();

          expect(game.descendants().whereType<Ball>(), isNotEmpty);
          final dinoBall = game.descendants().whereType<Ball>().single;

          expect(dinoBall != dashBall, isTrue);
        },
      );
    },
  );
}
