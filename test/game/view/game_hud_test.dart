// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import '../../helpers/helpers.dart';

void main() {
  group('GameHud', () {
    late GameBloc gameBloc;
    const initialState = GameState(
      score: 10,
      balls: 2,
      activatedDashNests: {},
      bonusHistory: [],
    );

    void _mockState(GameState state) {
      whenListen(
        gameBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    Future<void> _pumpHud(WidgetTester tester) async {
      await tester.pumpApp(
        GameHud(),
        gameBloc: gameBloc,
      );
    }

    setUp(() {
      gameBloc = MockGameBloc();
      _mockState(initialState);
    });

    testWidgets(
      'renders the current score',
      (tester) async {
        await _pumpHud(tester);
        expect(find.text(initialState.score.toString()), findsOneWidget);
      },
    );

    testWidgets(
      'renders the current ball number',
      (tester) async {
        await _pumpHud(tester);
        expect(
          find.byType(CircleAvatar),
          findsNWidgets(initialState.balls),
        );
      },
    );

    testWidgets('updates the score', (tester) async {
      await _pumpHud(tester);
      expect(find.text(initialState.score.toString()), findsOneWidget);

      _mockState(initialState.copyWith(score: 20));

      await tester.pump();
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('updates the ball number', (tester) async {
      await _pumpHud(tester);
      expect(
        find.byType(CircleAvatar),
        findsNWidgets(initialState.balls),
      );

      _mockState(initialState.copyWith(balls: 1));

      await tester.pump();
      expect(
        find.byType(CircleAvatar),
        findsNWidgets(1),
      );
    });
  });
}
