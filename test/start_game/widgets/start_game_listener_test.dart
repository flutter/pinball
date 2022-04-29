import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';

import '../../helpers/helpers.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late StartGameBloc startGameBloc;
  late CharacterThemeCubit characterThemeCubit;
  late PinballGame pinballGame;
  late GameFlowController gameController;

  setUpAll(() async {
    await Future.wait<void>(
      [
        ...SelectedCharacter.loadAssets(MockBuildContext()),
        ...StarAnimation.loadAssets(),
      ],
    );
  });

  setUp(() {
    startGameBloc = MockStartGameBloc();
    characterThemeCubit = MockCharacterThemeCubit();
    pinballGame = MockPinballGame();
    gameController = MockGameFlowController();

    when(() => pinballGame.gameFlowController).thenAnswer(
      (_) => gameController,
    );

    whenListen(
      characterThemeCubit,
      Stream.value(const CharacterThemeState.initial()),
      initialState: const CharacterThemeState.initial(),
    );
  });

  group('StartGameListener', () {
    testWidgets(
      'on selectCharacter status shows SelectCharacter dialog',
      (tester) async {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.selectCharacter),
          ),
          initialState: const StartGameState.initial(),
        );

        await tester.pumpApp(
          StartGameListener(
            game: pinballGame,
            child: const SizedBox.shrink(),
          ),
          startGameBloc: startGameBloc,
          characterThemeCubit: characterThemeCubit,
        );

        await tester.pump();

        expect(
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
          characterThemeCubit: characterThemeCubit,
        );

        await tester.pump();

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

        await tester.pump();

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

        await tester.pump();

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
