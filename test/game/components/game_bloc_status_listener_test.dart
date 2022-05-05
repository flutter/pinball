// ignore_for_file: type_annotate_public_apis, prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockPinballGame extends Mock implements PinballGame {}

class _MockBackbox extends Mock implements Backbox {}

class _MockActiveOverlaysNotifier extends Mock
    implements ActiveOverlaysNotifier {}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

void main() {
  group('GameBlocStatusListener', () {
    group('listenWhen', () {
      test('is true when the game over state has changed', () {
        final state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 1,
          rounds: 0,
          bonusHistory: const [],
          status: GameStatus.playing,
        );

        final previous = GameState.initial();
        expect(
          GameBlocStatusListener().listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      late PinballGame game;
      late Backbox backbox;
      late GameBlocStatusListener gameBlocStatusListener;
      late PinballPlayer pinballPlayer;
      late ActiveOverlaysNotifier overlays;

      setUp(() {
        game = _MockPinballGame();
        backbox = _MockBackbox();
        gameBlocStatusListener = GameBlocStatusListener();
        overlays = _MockActiveOverlaysNotifier();
        pinballPlayer = _MockPinballPlayer();

        gameBlocStatusListener.mockGameRef(game);

        when(
          () => backbox.initialsInput(
            score: any(named: 'score'),
            characterIconPath: any(named: 'characterIconPath'),
            onSubmit: any(named: 'onSubmit'),
          ),
        ).thenAnswer((_) async {});

        when(() => overlays.remove(any())).thenAnswer((_) => true);

        when(() => game.descendants().whereType<Backbox>())
            .thenReturn([backbox]);
        when(() => game.overlays).thenReturn(overlays);
        when(() => game.characterTheme).thenReturn(DashTheme());
        when(() => game.player).thenReturn(pinballPlayer);
      });

      test(
        'changes the backbox display when the game is over',
        () {
          final state = GameState(
            totalScore: 0,
            roundScore: 10,
            multiplier: 1,
            rounds: 0,
            bonusHistory: const [],
            status: GameStatus.gameOver,
          );
          gameBlocStatusListener.onNewState(state);

          verify(
            () => backbox.initialsInput(
              score: state.displayScore,
              characterIconPath: any(named: 'characterIconPath'),
              onSubmit: any(named: 'onSubmit'),
            ),
          ).called(1);
        },
      );

      test(
        'changes the backbox when it is not a game over',
        () {
          gameBlocStatusListener.onNewState(
            GameState.initial().copyWith(status: GameStatus.playing),
          );

          verify(() => overlays.remove(PinballGame.playButtonOverlay))
              .called(1);
        },
      );

      test(
        'plays the background music on start',
        () {
          gameBlocStatusListener.onNewState(
            GameState.initial().copyWith(status: GameStatus.playing),
          );

          verify(() => pinballPlayer.play(PinballAudio.backgroundMusic))
              .called(1);
        },
      );
    });
  });
}
