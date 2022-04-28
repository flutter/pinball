// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';

import '../../helpers/helpers.dart';

void main() {
  final game = PinballTestGame();

  group('PinballGamePage', () {
    late CharacterThemeCubit characterThemeCubit;
    late GameBloc gameBloc;

    setUp(() async {
      await Future.wait<void>(game.preLoadAssets());
      characterThemeCubit = MockCharacterThemeCubit();
      gameBloc = MockGameBloc();

      whenListen(
        characterThemeCubit,
        const Stream<CharacterThemeState>.empty(),
        initialState: const CharacterThemeState.initial(),
      );

      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );
    });

    testWidgets('renders PinballGameView', (tester) async {
      await tester.pumpApp(
        PinballGamePage(),
        characterThemeCubit: characterThemeCubit,
      );

      expect(find.byType(PinballGameView), findsOneWidget);
    });

    testWidgets(
      'renders the loading indicator while the assets load',
      (tester) async {
        final assetsManagerCubit = MockAssetsManagerCubit();
        final initialAssetsState = AssetsManagerState(
          loadables: [Future<void>.value()],
          loaded: const [],
        );
        whenListen(
          assetsManagerCubit,
          Stream.value(initialAssetsState),
          initialState: initialAssetsState,
        );

        await tester.pumpApp(
          PinballGameView(
            game: game,
          ),
          assetsManagerCubit: assetsManagerCubit,
          characterThemeCubit: characterThemeCubit,
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is LinearProgressIndicator && widget.value == 0.0,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
        'renders PinballGameLoadedView after resources have been loaded',
        (tester) async {
      final assetsManagerCubit = MockAssetsManagerCubit();
      final startGameBloc = MockStartGameBloc();

      final loadedAssetsState = AssetsManagerState(
        loadables: [Future<void>.value()],
        loaded: [Future<void>.value()],
      );
      whenListen(
        assetsManagerCubit,
        Stream.value(loadedAssetsState),
        initialState: loadedAssetsState,
      );
      whenListen(
        startGameBloc,
        Stream.value(StartGameState.initial()),
        initialState: StartGameState.initial(),
      );

      await tester.pumpApp(
        PinballGameView(
          game: game,
        ),
        assetsManagerCubit: assetsManagerCubit,
        characterThemeCubit: characterThemeCubit,
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      await tester.pump();

      expect(find.byType(PinballGameLoadedView), findsOneWidget);
    });

    group('route', () {
      Future<void> pumpRoute({
        required WidgetTester tester,
        required bool isDebugMode,
      }) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      PinballGamePage.route(
                        isDebugMode: isDebugMode,
                      ),
                    );
                  },
                  child: const Text('Tap me'),
                );
              },
            ),
          ),
          characterThemeCubit: characterThemeCubit,
        );

        await tester.tap(find.text('Tap me'));

        // We can't use pumpAndSettle here because the page renders a Flame game
        // which is an infinity animation, so it will timeout
        await tester.pump(); // Runs the button action
        await tester.pump(); // Runs the navigation
      }

      testWidgets('route creates the correct non debug game', (tester) async {
        await pumpRoute(tester: tester, isDebugMode: false);
        expect(
          find.byWidgetPredicate(
            (w) => w is PinballGameView && w.game is! DebugPinballGame,
          ),
          findsOneWidget,
        );
      });

      testWidgets('route creates the correct debug game', (tester) async {
        await pumpRoute(tester: tester, isDebugMode: true);
        expect(
          find.byWidgetPredicate(
            (w) => w is PinballGameView && w.game is DebugPinballGame,
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('PinballGameView', () {
    final gameBloc = MockGameBloc();
    final startGameBloc = MockStartGameBloc();

    setUp(() async {
      await Future.wait<void>(game.preLoadAssets());

      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      whenListen(
        startGameBloc,
        Stream.value(StartGameState.initial()),
        initialState: StartGameState.initial(),
      );
    });

    testWidgets('renders game', (tester) async {
      await tester.pumpApp(
        PinballGameView(game: game),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      expect(
        find.byWidgetPredicate((w) => w is GameWidget<PinballGame>),
        findsOneWidget,
      );
      // TODO(arturplaczek): add Visibility to GameHud based on StartGameBloc
      // status
      // expect(
      //   find.byType(GameHud),
      //   findsNothing,
      // );
    });

    testWidgets('renders a hud on play state', (tester) async {
      final startGameState = StartGameState.initial().copyWith(
        status: StartGameStatus.play,
      );

      whenListen(
        startGameBloc,
        Stream.value(startGameState),
        initialState: startGameState,
      );

      await tester.pumpApp(
        PinballGameView(game: game),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      expect(
        find.byType(GameHud),
        findsOneWidget,
      );
    });
  });
}
