import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  late GameBloc gameBloc;
  late StreamController<GameState> stateController;
  const totalScore = 123456789;
  const roundScore = 1234;
  const initialState = GameState(
    totalScore: totalScore,
    roundScore: roundScore,
    multiplier: 1,
    rounds: 1,
    bonusHistory: [],
  );

  setUp(() {
    gameBloc = _MockGameBloc();
    stateController = StreamController<GameState>()..add(initialState);

    whenListen(
      gameBloc,
      stateController.stream,
      initialState: initialState,
    );
  });

  group('ScoreView', () {
    testWidgets('renders score', (tester) async {
      await tester.pumpApp(
        const ScoreView(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(
        find.text(initialState.displayScore.formatScore()),
        findsOneWidget,
      );
    });

    testWidgets('renders game over', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      stateController.add(
        initialState.copyWith(
          rounds: 0,
        ),
      );

      await tester.pumpApp(
        const ScoreView(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(find.text(l10n.gameOver), findsOneWidget);
    });

    testWidgets('updates the score', (tester) async {
      await tester.pumpApp(
        const ScoreView(),
        gameBloc: gameBloc,
      );

      expect(
        find.text(initialState.displayScore.formatScore()),
        findsOneWidget,
      );

      final newState = initialState.copyWith(
        roundScore: 5678,
      );

      stateController.add(newState);

      await tester.pump();

      expect(
        find.text(newState.displayScore.formatScore()),
        findsOneWidget,
      );
    });
  });
}
