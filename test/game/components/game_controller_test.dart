// ignore_for_file: type_annotate_public_apis, prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

// TODO(erickzanardo): This will not be needed anymore when
// this issue is merged: https://github.com/flame-engine/flame/issues/1513
class WrappedGameController extends GameController {
  WrappedGameController(this._gameRef);

  final PinballGame _gameRef;

  @override
  PinballGame get gameRef => _gameRef;
}

void main() {
  group('GameController', () {
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
          GameController().listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      late PinballGame game;
      late Backboard backboard;
      late CameraController cameraController;
      late GameController gameController;
      late ActiveOverlaysNotifier overlays;

      setUp(() {
        game = MockPinballGame();
        backboard = MockBackboard();
        cameraController = MockCameraController();
        gameController = WrappedGameController(game);
        overlays = MockActiveOverlaysNotifier();

        when(backboard.gameOverMode).thenAnswer((_) async {});
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
          gameController.onNewState(
            GameState(
              score: 10,
              balls: 0,
              activatedBonusLetters: const [],
              bonusHistory: const [],
              activatedDashNests: const {},
            ),
          );

          verify(backboard.gameOverMode).called(1);
          verify(cameraController.focusOnBackboard).called(1);
        },
      );

      test(
        'changes the backboard and camera correctly when it is not a game over',
        () {
          gameController.onNewState(GameState.initial());

          verify(backboard.waitingMode).called(1);
          verify(cameraController.focusOnGame).called(1);
          verify(() => overlays.remove(PinballGame.playButtonOverlay))
              .called(1);
        },
      );
    });
  });
}
