import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';

/// Listns to the [GameBloc] and updates the game accoringly.
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
        gameRef.audio.backgroundMusic();
        gameRef.firstChild<CameraController>()?.focusOnGame();
        gameRef.overlays.remove(PinballGame.playButtonOverlay);
        break;
      case GameStatus.gameOver:
        gameRef.descendants().whereType<Backbox>().first.initialsInput(
              score: state.displayScore,
              characterIconPath: gameRef.characterTheme.leaderboardIcon.keyName,
            );
        gameRef.firstChild<CameraController>()!.focusOnGameOverBackbox();
        break;
    }
  }
}
