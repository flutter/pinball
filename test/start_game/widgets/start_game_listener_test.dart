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

class _MockGameBloc extends Mock implements GameBloc {}

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

void main() {
  late StartGameBloc startGameBloc;
  late PinballAudioPlayer pinballAudioPlayer;
  late CharacterThemeCubit characterThemeCubit;

  group('StartGameListener', () {
    setUp(() async {
      await mockFlameImages();

      startGameBloc = _MockStartGameBloc();
      pinballAudioPlayer = _MockPinballAudioPlayer();
      characterThemeCubit = _MockCharacterThemeCubit();
    });

    group('on selectCharacter status', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = _MockGameBloc();

        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      testWidgets(
        'calls GameStarted event',
        (tester) async {
          whenListen(
            startGameBloc,
            Stream.value(
              const StartGameState(
                status: StartGameStatus.selectCharacter,
              ),
            ),
            initialState: const StartGameState.initial(),
          );

          await tester.pumpApp(
            const StartGameListener(
              child: SizedBox.shrink(),
            ),
            gameBloc: gameBloc,
            startGameBloc: startGameBloc,
          );

          verify(() => gameBloc.add(const GameStarted())).called(1);
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

          await tester.pumpApp(
            const StartGameListener(
              child: SizedBox.shrink(),
            ),
            gameBloc: gameBloc,
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
          const StartGameListener(
            child: SizedBox.shrink(),
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
          const StartGameListener(
            child: SizedBox.shrink(),
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
          const StartGameListener(
            child: SizedBox.shrink(),
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
            const StartGameListener(
              child: SizedBox.shrink(),
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
            const StartGameListener(
              child: SizedBox.shrink(),
            ),
            startGameBloc: startGameBloc,
            pinballAudioPlayer: pinballAudioPlayer,
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

          verify(() => pinballAudioPlayer.play(PinballAudio.ioPinballVoiceOver))
              .called(1);
        },
      );
    });
  });
}
