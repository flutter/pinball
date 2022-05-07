// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

class _MockBallCubit extends Mock implements BallCubit {}

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
        'onNewState calls onThemeChanged on the ball bloc',
        (game) async {
          final ballBloc = _MockBallCubit();
          whenListen(
            ballBloc,
            const Stream<BallState>.empty(),
            initialState: const BallState.initial(),
          );
          final ball = Ball.test(bloc: ballBloc);
          final behavior = BallThemingBehavior();
          await game.pump([
            ball,
            behavior,
            ZCanvasComponent(),
            Plunger.test(compressionDistance: 10),
          ]);

          const dinoThemeState = CharacterThemeState(theme.DinoTheme());
          behavior.onNewState(dinoThemeState);
          await game.ready();

          verify(() => ballBloc.onThemeChanged(dinoThemeState.characterTheme))
              .called(1);
        },
      );
    },
  );
}
