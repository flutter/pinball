// ignore_for_file: type_annotate_public_apis, prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockPinballGame extends Mock implements PinballGame {}

class _MockBackboard extends Mock implements Backboard {}

class _MockCameraController extends Mock implements CameraController {}

class _MockActiveOverlaysNotifier extends Mock
    implements ActiveOverlaysNotifier {}

class _MockPinballAudio extends Mock implements PinballAudio {}

void main() {
  group('GameFlowController', () {
    group('listenWhen', () {
      test('is true when the game over state has changed', () {
        final state = GameState(
          score: 10,
          multiplier: 1,
          rounds: 0,
          bonusHistory: const [],
        );

        final previous = GameState.initial();
        expect(
          GameFlowController(_MockPinballGame()).listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      late PinballGame game;
      late Backboard backboard;
      late CameraController cameraController;
      late GameFlowController gameFlowController;
      late PinballAudio pinballAudio;
      late ActiveOverlaysNotifier overlays;

      setUp(() {
        game = _MockPinballGame();
        backboard = _MockBackboard();
        cameraController = _MockCameraController();
        gameFlowController = GameFlowController(game);
        overlays = _MockActiveOverlaysNotifier();
        pinballAudio = _MockPinballAudio();

        when(
          () => backboard.gameOverMode(
            score: any(named: 'score'),
            characterIconPath: any(named: 'characterIconPath'),
            onSubmit: any(named: 'onSubmit'),
          ),
        ).thenAnswer((_) async {});
        when(backboard.waitingMode).thenAnswer((_) async {});
        when(cameraController.focusOnBackboard).thenAnswer((_) async {});
        when(cameraController.focusOnGame).thenAnswer((_) async {});

        when(() => overlays.remove(any())).thenAnswer((_) => true);

        when(game.firstChild<Backboard>).thenReturn(backboard);
        when(game.firstChild<CameraController>).thenReturn(cameraController);
        when(() => game.overlays).thenReturn(overlays);
        when(() => game.characterTheme).thenReturn(DashTheme());
        when(() => game.audio).thenReturn(pinballAudio);
      });

      test(
        'changes the backboard and camera correctly when it is a game over',
        () {
          gameFlowController.onNewState(
            GameState(
              score: 10,
              multiplier: 1,
              rounds: 0,
              bonusHistory: const [],
            ),
          );

          verify(
            () => backboard.gameOverMode(
              score: 0,
              characterIconPath: any(named: 'characterIconPath'),
              onSubmit: any(named: 'onSubmit'),
            ),
          ).called(1);
          verify(cameraController.focusOnBackboard).called(1);
        },
      );

      test(
        'changes the backboard and camera correctly when it is not a game over',
        () {
          gameFlowController.onNewState(GameState.initial());

          verify(backboard.waitingMode).called(1);
          verify(cameraController.focusOnGame).called(1);
          verify(() => overlays.remove(PinballGame.playButtonOverlay))
              .called(1);
        },
      );

      test(
        'plays the background music on start',
        () {
          gameFlowController.onNewState(GameState.initial());

          verify(pinballAudio.backgroundMusic).called(1);
        },
      );
    });
  });
}
