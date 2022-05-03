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
  const score = 123456789;
  const initialState = GameState(
    score: score,
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

      expect(find.text(score.formatScore()), findsOneWidget);
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

      expect(find.text(score.formatScore()), findsOneWidget);

      final newState = initialState.copyWith(
        score: 987654321,
      );

      stateController.add(newState);

      await tester.pump();

      expect(find.text(newState.score.formatScore()), findsOneWidget);
    });
  });
}
