import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_ui/pinball_ui.dart';

import '../../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  group('RoundCountDisplay renders', () {
    late GameBloc gameBloc;
    const initialState = GameState(
      totalScore: 0,
      roundScore: 0,
      multiplier: 1,
      rounds: 3,
      bonusHistory: [],
      status: GameStatus.playing,
    );

    setUp(() {
      gameBloc = _MockGameBloc();

      whenListen(
        gameBloc,
        Stream.value(initialState),
        initialState: initialState,
      );
    });

    testWidgets('three active round indicator', (tester) async {
      await tester.pumpApp(
        const RoundCountDisplay(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(find.byType(RoundIndicator), findsNWidgets(3));
    });

    testWidgets('two active round indicator', (tester) async {
      final state = initialState.copyWith(
        rounds: 2,
      );
      whenListen(
        gameBloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpApp(
        const RoundCountDisplay(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is RoundIndicator && widget.isActive,
        ),
        findsNWidgets(2),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is RoundIndicator && !widget.isActive,
        ),
        findsOneWidget,
      );
    });

    testWidgets('one active round indicator', (tester) async {
      final state = initialState.copyWith(
        rounds: 1,
      );
      whenListen(
        gameBloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpApp(
        const RoundCountDisplay(),
        gameBloc: gameBloc,
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is RoundIndicator && widget.isActive,
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is RoundIndicator && !widget.isActive,
        ),
        findsNWidgets(2),
      );
    });
  });

  testWidgets('active round indicator is displaying with proper color',
      (tester) async {
    await tester.pumpApp(
      const RoundIndicator(isActive: true),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == PinballColors.yellow,
      ),
      findsOneWidget,
    );
  });

  testWidgets('inactive round indicator is displaying with proper color',
      (tester) async {
    await tester.pumpApp(
      const RoundIndicator(isActive: false),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.color == PinballColors.yellow.withAlpha(128),
      ),
      findsOneWidget,
    );
  });
}
