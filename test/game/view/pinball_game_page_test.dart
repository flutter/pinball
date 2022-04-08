// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  const theme = PinballTheme(characterTheme: DashTheme());
  final game = PinballGameTest();

  group('PinballGamePage', () {
    testWidgets('renders PinballGameView', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(
        PinballGamePage(theme: theme, game: game),
        gameBloc: gameBloc,
      );
      expect(find.byType(PinballGameView), findsOneWidget);
    });

    testWidgets(
      'renders the loading indicator while the assets load',
      (tester) async {
        final gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          Stream.value(const GameState.initial()),
          initialState: const GameState.initial(),
        );

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
          PinballGamePage(theme: theme, game: game),
          gameBloc: gameBloc,
          assetsManagerCubit: assetsManagerCubit,
        );
        expect(find.text('0.0'), findsOneWidget);

        final loadedAssetsState = AssetsManagerState(
          loadables: [Future<void>.value()],
          loaded: [Future<void>.value()],
        );
        whenListen(
          assetsManagerCubit,
          Stream.value(loadedAssetsState),
          initialState: loadedAssetsState,
        );

        await tester.pump();
        expect(find.byType(PinballGameView), findsOneWidget);
      },
    );

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
                        theme: theme,
                        isDebugMode: isDebugMode,
                      ),
                    );
                  },
                  child: const Text('Tap me'),
                );
              },
            ),
          ),
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
    testWidgets('renders game and a hud', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(
        PinballGameView(theme: theme, game: game),
        gameBloc: gameBloc,
      );

      expect(
        find.byWidgetPredicate((w) => w is GameWidget<PinballGame>),
        findsOneWidget,
      );
      expect(
        find.byType(GameHud),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders a game over dialog when the user has lost',
      (tester) async {
        final gameBloc = MockGameBloc();
        const state = GameState(
          score: 0,
          balls: 0,
          activatedBonusLetters: [],
          activatedDashNests: {},
          bonusHistory: [],
        );

        whenListen(
          gameBloc,
          Stream.value(state),
          initialState: GameState.initial(),
        );

        await tester.pumpApp(
          PinballGameView(theme: theme, game: game),
          gameBloc: gameBloc,
        );
        await tester.pump();

        expect(find.byType(GameOverDialog), findsOneWidget);
      },
    );
  });
}
