import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';

/// Listens to the [GameBloc] and updates the game accordingly.
class GameBlocStatusListener extends Component
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.status != newState.status;
  }

  @override
  void onNewState(GameState state) {
    switch (state.status) {
      case GameStatus.waiting:
        break;
      case GameStatus.playing:
        gameRef.player.play(PinballAudio.backgroundMusic);
        gameRef.firstChild<CameraController>()?.focusOnGame();
        gameRef.overlays.remove(PinballGame.playButtonOverlay);
        break;
      case GameStatus.gameOver:
        gameRef.descendants().whereType<Backbox>().first.requestInitials(
              score: state.displayScore,
              character: gameRef.characterTheme,
            );
        gameRef.firstChild<CameraController>()!.focusOnGameOverBackbox();
        break;
    }
  }
}
