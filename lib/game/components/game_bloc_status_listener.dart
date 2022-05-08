import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

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
        readProvider<PinballAudioPlayer>().play(PinballAudio.backgroundMusic);
        gameRef
            .descendants()
            .whereType<Flipper>()
            .forEach(_addFlipperKeyControls);
        gameRef
            .descendants()
            .whereType<Plunger>()
            .forEach(_addPlungerKeyControls);

        gameRef.overlays.remove(PinballGame.playButtonOverlay);
        break;
      case GameStatus.gameOver:
        readProvider<PinballAudioPlayer>().play(PinballAudio.gameOverVoiceOver);
        gameRef.descendants().whereType<Backbox>().first.requestInitials(
              score: state.displayScore,
              character: readBloc<CharacterThemeCubit, CharacterThemeState>()
                  .state
                  .characterTheme,
            );

        gameRef
            .descendants()
            .whereType<Flipper>()
            .forEach(_removeFlipperKeyControls);
        gameRef
            .descendants()
            .whereType<Plunger>()
            .forEach(_removePlungerKeyControls);
        break;
    }
  }

  void _addPlungerKeyControls(Plunger plunger) =>
      plunger.add(PlungerKeyControllingBehavior());

  void _removePlungerKeyControls(Plunger plunger) =>
      plunger.remove(PlungerKeyControllingBehavior());

  void _addFlipperKeyControls(Flipper flipper) => flipper
    ..add(FlipperKeyControllingBehavior())
    ..moveDown();

  void _removeFlipperKeyControls(Flipper flipper) => flipper
      .descendants()
      .whereType<FlipperKeyControllingBehavior>()
      .forEach(flipper.remove);
}
