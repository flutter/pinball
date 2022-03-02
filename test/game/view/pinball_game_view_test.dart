import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PinballGameView', () {
    testWidgets('renders', (tester) async {
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
        const state = GameState(score: 0, balls: 0);
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
