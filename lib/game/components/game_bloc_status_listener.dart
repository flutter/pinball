import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// Listens to the [GameBloc] and updates the game accordingly.
class GameBlocStatusListener extends Component
    with FlameBlocListenable<GameBloc, GameState>, HasGameRef {
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
        readProvider<PinballPlayer>().play(PinballAudio.backgroundMusic);
        gameRef.overlays.remove(PinballGame.playButtonOverlay);
        break;
      case GameStatus.gameOver:
        readProvider<PinballPlayer>().play(PinballAudio.gameOverVoiceOver);
        gameRef.descendants().whereType<Backbox>().first.requestInitials(
              score: state.displayScore,
              character: readProvider<CharacterTheme>(),
            );
        break;
    }
  }
}
