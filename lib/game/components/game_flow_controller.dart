import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Component] that controls the game over and game restart logic
class GameFlowController extends Component
    with BlocComponent<GameBloc, GameState>, HasGameRef {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.isGameOver != newState.isGameOver;
  }

  @override
  void onNewState(GameState state) {
    if (state.isGameOver) {
      gameOver();
    } else {
      start();
    }
  }

  /// Puts the game on a game over state
  void gameOver() {
    gameRef.firstChild<Backboard>()?.gameOverMode();
    gameRef.firstChild<CameraController>()?.focusOnBackboard();
  }

  /// Puts the game on a playing state
  void start() {
    gameRef.firstChild<Backboard>()?.waitingMode();
    gameRef.firstChild<CameraController>()?.focusOnGame();
    gameRef.overlays.remove(PinballGame.playButtonOverlay);
  }
}
