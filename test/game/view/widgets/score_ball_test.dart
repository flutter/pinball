import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/theme/app_colors.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ScoreBalls renders', () {
    late GameBloc gameBloc;
    const initialState = GameState(
      score: 0,
      balls: 3,
      bonusHistory: [],
    );

    setUp(() {
      gameBloc = MockGameBloc();

      whenListen(
        gameBloc,
        Stream.value(initialState),
        initialState: initialState,
      );
    });

    testWidgets('three active balls', (tester) async {
      await tester.pumpApp(
        const ScoreBalls(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(find.byType(ScoreBall), findsNWidgets(3));
    });

    testWidgets('two active balls', (tester) async {
      final state = initialState.copyWith(
        balls: 2,
      );
      whenListen(
        gameBloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpApp(
        const ScoreBalls(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is ScoreBall && widget.isActive,
        ),
        findsNWidgets(2),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is ScoreBall && !widget.isActive,
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('active score ball is displaying with proper color',
      (tester) async {
    await tester.pumpApp(
      const ScoreBall(isActive: true),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == AppColors.orange,
      ),
      findsOneWidget,
    );
  });

  testWidgets('inactive score ball is displaying with proper color',
      (tester) async {
    await tester.pumpApp(
      const ScoreBall(isActive: false),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.color == AppColors.orange.withAlpha(128),
      ),
      findsOneWidget,
    );
  });
}
