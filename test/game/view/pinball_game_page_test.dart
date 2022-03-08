import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PinballGamePage', () {
    testWidgets('renders PinballGameView', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(const PinballGamePage(), gameBloc: gameBloc);
      expect(find.byType(PinballGameView), findsOneWidget);
    });

    testWidgets('route returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push<void>(PinballGamePage.route());
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
    testWidgets('renders game', (tester) async {
      final gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      await tester.pumpApp(const PinballGameView(), gameBloc: gameBloc);
      expect(
        find.byWidgetPredicate((w) => w is GameWidget<PinballGame>),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders a game over dialog when the user has lost',
      (tester) async {
        final gameBloc = MockGameBloc();
        const state = GameState(score: 0, balls: 0, bonusLetter: []);
        whenListen(
          gameBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(const PinballGameView(), gameBloc: gameBloc);
        await tester.pump();

        expect(
          find.text('Game Over'),
          findsOneWidget,
        );
      },
    );
  });
}
