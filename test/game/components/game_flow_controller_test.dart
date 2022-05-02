// ignore_for_file: type_annotate_public_apis, prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

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
          GameFlowController(MockPinballGame()).listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      late PinballGame game;
      late Backbox backbox;
      late CameraController cameraController;
      late GameFlowController gameFlowController;
      late ActiveOverlaysNotifier overlays;

      setUp(() {
        game = MockPinballGame();
        backbox = MockBackbox();
        cameraController = MockCameraController();
        gameFlowController = GameFlowController(game);
        overlays = MockActiveOverlaysNotifier();

        when(
          () => backbox.initialsInput(
            score: any(named: 'score'),
            characterIconPath: any(named: 'characterIconPath'),
            onSubmit: any(named: 'onSubmit'),
          ),
        ).thenAnswer((_) async {});
        when(cameraController.focusOnWaitingBackbox).thenAnswer((_) async {});
        when(cameraController.focusOnGame).thenAnswer((_) async {});

        when(() => overlays.remove(any())).thenAnswer((_) => true);

        when(game.firstChild<Backbox>).thenReturn(backbox);
        when(game.firstChild<CameraController>).thenReturn(cameraController);
        when(() => game.overlays).thenReturn(overlays);
        when(() => game.characterTheme).thenReturn(DashTheme());
      });

      test(
        'changes the backbox display and camera correctly '
        'when the game is over',
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
            () => backbox.initialsInput(
              score: 0,
              characterIconPath: any(named: 'characterIconPath'),
              onSubmit: any(named: 'onSubmit'),
            ),
          ).called(1);
          verify(cameraController.focusOnWaitingBackbox).called(1);
        },
      );

      test(
        'changes the backbox and camera correctly when it is not a game over',
        () {
          gameFlowController.onNewState(GameState.initial());

          verify(cameraController.focusOnGame).called(1);
          verify(() => overlays.remove(PinballGame.playButtonOverlay))
              .called(1);
        },
      );
    });
  });
}
