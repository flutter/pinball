// ignore_for_file: type_annotate_public_apis, prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GameFlowController', () {
    group('listenWhen', () {
      test('is true when the game over state has changed', () {
        final state = GameState(
          score: 10,
          balls: 0,
          activatedBonusLetters: const [],
          bonusHistory: const [],
          activatedDashNests: const {},
        );

        final previous = GameState.initial();
        expect(
          GameFlowController(MockPinballGame()).listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      late PinballGame game;
      late Backboard backboard;
      late CameraController cameraController;
      late GameFlowController gameFlowController;
      late ActiveOverlaysNotifier overlays;

      setUp(() {
        game = MockPinballGame();
        backboard = MockBackboard();
        cameraController = MockCameraController();
        gameFlowController = GameFlowController(game);
        overlays = MockActiveOverlaysNotifier();

        when(
          () => backboard.gameOverMode(
            score: any(named: 'score'),
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
      });

      test(
        'changes the backboard and camera correctly when it is a game over',
        () {
          gameFlowController.onNewState(
            GameState(
              score: 10,
              balls: 0,
              activatedBonusLetters: const [],
              bonusHistory: const [],
              activatedDashNests: const {},
            ),
          );

          verify(
            () => backboard.gameOverMode(
              score: 0,
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
    });
  });
}
