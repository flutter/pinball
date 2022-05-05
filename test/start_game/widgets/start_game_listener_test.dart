import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/how_to_play/how_to_play.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';

import '../../helpers/helpers.dart';

class _MockStartGameBloc extends Mock implements StartGameBloc {}

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class _MockPinballGame extends Mock implements PinballGame {}

class _MockGameFlowController extends Mock implements GameFlowController {}

class _MockPinballAudio extends Mock implements PinballAudio {}

void main() {
  late StartGameBloc startGameBloc;
  late PinballGame pinballGame;
  late PinballAudio pinballAudio;
  late CharacterThemeCubit characterThemeCubit;

  group('StartGameListener', () {
    setUp(() async {
      await mockFlameImages();

      startGameBloc = _MockStartGameBloc();
      pinballGame = _MockPinballGame();
      pinballAudio = _MockPinballAudio();
      characterThemeCubit = _MockCharacterThemeCubit();
    });

    group('on selectCharacter status', () {
      testWidgets(
        'calls start on the game controller',
        (tester) async {
          whenListen(
            startGameBloc,
            Stream.value(
              const StartGameState(status: StartGameStatus.selectCharacter),
            ),
            initialState: const StartGameState.initial(),
          );
          final gameController = _MockGameFlowController();
          when(() => pinballGame.gameFlowController)
              .thenAnswer((_) => gameController);

          await tester.pumpApp(
            StartGameListener(
              game: pinballGame,
              child: const SizedBox.shrink(),
            ),
            startGameBloc: startGameBloc,
          );

          verify(gameController.start).called(1);
        },
      );

      testWidgets(
        'shows SelectCharacter dialog',
        (tester) async {
          whenListen(
            startGameBloc,
            Stream.value(
              const StartGameState(status: StartGameStatus.selectCharacter),
            ),
            initialState: const StartGameState.initial(),
          );
          whenListen(
            characterThemeCubit,
            Stream.value(const CharacterThemeState.initial()),
            initialState: const CharacterThemeState.initial(),
          );
          final gameController = _MockGameFlowController();
          when(() => pinballGame.gameFlowController)
              .thenAnswer((_) => gameController);

          await tester.pumpApp(
            StartGameListener(
              game: pinballGame,
              child: const SizedBox.shrink(),
            ),
            startGameBloc: startGameBloc,
            characterThemeCubit: characterThemeCubit,
          );

          await tester.pump(kThemeAnimationDuration);

          expect(
            find.byType(CharacterSelectionDialog),
            findsOneWidget,
          );
        },
      );
    });

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

    group('on dismiss HowToPlayDialog', () {
      setUp(() {
        whenListen(
          startGameBloc,
          Stream.value(
            const StartGameState(status: StartGameStatus.howToPlay),
          ),
          initialState: const StartGameState.initial(),
        );
      });

      testWidgets(
        'adds HowToPlayFinished event',
        (tester) async {
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

      testWidgets(
        'plays the I/O Pinball voice over audio',
        (tester) async {
          await tester.pumpApp(
            StartGameListener(
              game: pinballGame,
              child: const SizedBox.shrink(),
            ),
            startGameBloc: startGameBloc,
            pinballAudio: pinballAudio,
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

          verify(pinballAudio.ioPinballVoiceOver).called(1);
        },
      );
    });
  });
}
