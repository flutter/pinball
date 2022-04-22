import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';

import '../../../helpers/helpers.dart';

void main() {
  late GameBloc gameBloc;
  late StreamController<GameState> stateController;
  const score = 123456789;
  const initialState = GameState(
    score: score,
    balls: 1,
    bonusHistory: [],
  );

  setUp(() {
    gameBloc = MockGameBloc();
    stateController = StreamController<GameState>()..add(initialState);

    whenListen(
      gameBloc,
      stateController.stream,
      initialState: initialState,
    );
  });

  String _formatScore(int score) {
    final numberFormatter = NumberFormat.decimalPattern('en_US');
    return numberFormatter.format(score).replaceAll(',', '.');
  }

  group('ScoreView', () {
    testWidgets('renders score', (tester) async {
      await tester.pumpApp(
        const ScoreView(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(find.text(_formatScore(score)), findsOneWidget);
    });

    testWidgets('renders game over', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      stateController.add(
        initialState.copyWith(
          balls: 0,
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

      expect(find.text('$score'), findsOneWidget);

      final newState = initialState.copyWith(
        score: 987654321,
      );

      stateController.add(newState);

      await tester.pump();

      expect(find.text(_formatScore(newState.score)), findsOneWidget);
    });
  });
}
