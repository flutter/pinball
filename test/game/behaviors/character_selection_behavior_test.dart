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
import 'package:platform_helper/platform_helper.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      theme.Assets.images.dash.ball.keyName,
      theme.Assets.images.dino.ball.keyName,
      theme.Assets.images.dash.background.keyName,
      theme.Assets.images.dino.background.keyName,
    ]);
  }

  Future<void> pump(
    List<Component> children, {
    CharacterThemeCubit? characterThemeBloc,
    PlatformHelper? platformHelper,
  }) async {
    await ensureAdd(
      FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
        value: characterThemeBloc ?? CharacterThemeCubit(),
        children: [
          FlameProvider.value(
            platformHelper ?? _MockPlatformHelper(),
            children: children,
          ),
        ],
      ),
    );
  }
}

class _MockBallCubit extends Mock implements BallCubit {}

class _MockArcadeBackgroundCubit extends Mock implements ArcadeBackgroundCubit {
}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'CharacterSelectionBehavior',
    () {
      final flameTester = FlameTester(_TestGame.new);

      test('can be instantiated', () {
        expect(
          CharacterSelectionBehavior(),
          isA<CharacterSelectionBehavior>(),
        );
      });

      flameTester.test(
        'loads',
        (game) async {
          final behavior = CharacterSelectionBehavior();
          await game.pump([behavior]);
          expect(game.descendants(), contains(behavior));
        },
      );

      flameTester.test(
        'onNewState calls onCharacterSelected on the arcade background bloc',
        (game) async {
          final platformHelper = _MockPlatformHelper();
          when(() => platformHelper.isMobile).thenAnswer((_) => false);
          final arcadeBackgroundBloc = _MockArcadeBackgroundCubit();
          whenListen(
            arcadeBackgroundBloc,
            const Stream<ArcadeBackgroundState>.empty(),
            initialState: const ArcadeBackgroundState.initial(),
          );
          final arcadeBackground =
              ArcadeBackground.test(bloc: arcadeBackgroundBloc);
          final behavior = CharacterSelectionBehavior();
          await game.pump(
            [
              arcadeBackground,
              behavior,
              ZCanvasComponent(),
              Plunger.test(compressionDistance: 10),
              Ball.test(),
            ],
            platformHelper: platformHelper,
          );

          const dinoThemeState = CharacterThemeState(theme.DinoTheme());
          behavior.onNewState(dinoThemeState);
          await game.ready();

          verify(
            () => arcadeBackgroundBloc
                .onCharacterSelected(dinoThemeState.characterTheme),
          ).called(1);
        },
      );

      flameTester.test(
        'onNewState calls onCharacterSelected on the ball bloc',
        (game) async {
          final platformHelper = _MockPlatformHelper();
          when(() => platformHelper.isMobile).thenAnswer((_) => false);
          final ballBloc = _MockBallCubit();
          whenListen(
            ballBloc,
            const Stream<BallState>.empty(),
            initialState: const BallState.initial(),
          );
          final ball = Ball.test(bloc: ballBloc);
          final behavior = CharacterSelectionBehavior();
          await game.pump(
            [
              ball,
              behavior,
              ZCanvasComponent(),
              Plunger.test(compressionDistance: 10),
              ArcadeBackground.test(),
            ],
            platformHelper: platformHelper,
          );

          const dinoThemeState = CharacterThemeState(theme.DinoTheme());
          behavior.onNewState(dinoThemeState);
          await game.ready();

          verify(
            () => ballBloc.onCharacterSelected(dinoThemeState.characterTheme),
          ).called(1);
        },
      );
    },
  );
}
