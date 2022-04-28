import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';

import '../../helpers/helpers.dart';

void main() {
  late StartGameBloc startGameBloc;
  late PinballGame pinballGame;

  group('StartGameListener', () {
    setUp(() {
      startGameBloc = MockStartGameBloc();
      pinballGame = MockPinballGame();
    });

    // TODO(arturplaczek): need to fix that test
    testWidgets(
      'on selectCharacter status calls start on the game controller and shows '
      'SelectCharacter dialog',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.selectCharacter),
          ),
          initialState: const StartGameState.initial(),
        );
        final gameController = MockGameFlowController();
        when(() => pinballGame.gameFlowController)
            .thenAnswer((_) => gameController);

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            selectCharacterDelay: 0,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
        );
        verify(gameController.start).called(1);

        await tester.pumpAndSettle(kThemeAnimationDuration);

        await expectLater(
          find.byType(CharacterSelectionDialog),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'on howToPlay status shows HowToPlay dialog',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.howToPlay),
          ),
          initialState: const StartGameState.initial(),
        );

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(HowToPlayDialog),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'do nothing on play status',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.play),
          ),
          initialState: const StartGameState.initial(),
        );

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(HowToPlayDialog),
          findsNothing,
        );
        expect(
          find.byType(CharacterSelectionDialog),
          findsNothing,
        );
      },
    );

    testWidgets(
      'do nothing on initial status',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.initial),
          ),
          initialState: const StartGameState.initial(),
        );

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(HowToPlayDialog),
          findsNothing,
        );
        expect(
          find.byType(CharacterSelectionDialog),
          findsNothing,
        );
      },
    );

    testWidgets(
      'adds HowToPlayFinished event after closing HowToPlayDialog',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.howToPlay),
          ),
          initialState: const StartGameState.initial(),
        );

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
        );
        await tester.pumpAndSettle();

        expect(
          find.byType(HowToPlayDialog),
          findsOneWidget,
        );
        await tester.tapAt(const Offset(1, 1));
        await tester.pumpAndSettle();

        expect(
          find.byType(HowToPlayDialog),
          findsNothing,
        );
        await tester.pumpAndSettle();

        verify(
          () => startGameBloc.add(const HowToPlayFinished()),
        ).called(1);
      },
    );
  });
}
