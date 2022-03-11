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

  group('PinballGamePage', () {
    testWidgets('renders PinballGameView', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(
        PinballGamePage(theme: theme),
        gameBloc: gameBloc,
      );
      expect(find.byType(PinballGameView), findsOneWidget);
    });

    testWidgets('route returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(PinballGamePage.route(theme: theme));
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

      expect(find.byType(PinballGamePage), findsOneWidget);
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
        PinballGameView(theme: theme),
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
          bonusHistory: [],
        );

        whenListen(
          gameBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          const PinballGameView(theme: theme),
          gameBloc: gameBloc,
        );
        await tester.pump();

        expect(
          find.text('Game Over'),
          findsOneWidget,
        );
      },
    );

    testWidgets('renders the real game when not in debug mode', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(
        const PinballGameView(theme: theme, isDebugMode: false),
        gameBloc: gameBloc,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is GameWidget<PinballGame> && w.game is! DebugPinballGame,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders the debug game when on debug mode', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(
        const PinballGameView(theme: theme),
        gameBloc: gameBloc,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is GameWidget<PinballGame> && w.game is DebugPinballGame,
        ),
        findsOneWidget,
      );
    });
  });
}
