import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:platform_helper/platform_helper.dart';

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
        _resetBonuses();
        gameRef
            .descendants()
            .whereType<Flipper>()
            .forEach(_addFlipperBehaviors);
        gameRef
            .descendants()
            .whereType<Plunger>()
            .forEach(_addPlungerBehaviors);

        gameRef.overlays.remove(PinballGame.playButtonOverlay);
        gameRef.overlays.remove(PinballGame.replayButtonOverlay);
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
            .forEach(_removeFlipperBehaviors);
        gameRef
            .descendants()
            .whereType<Plunger>()
            .forEach(_removePlungerBehaviors);
        break;
    }
  }

  void _resetBonuses() {
    gameRef
        .descendants()
        .whereType<FlameBlocProvider<GoogleWordCubit, GoogleWordState>>()
        .single
        .bloc
        .onReset();
  }

  void _addPlungerBehaviors(Plunger plunger) {
    final platformHelper = readProvider<PlatformHelper>();
    const pullingStrength = 7.0;
    final provider =
        plunger.firstChild<FlameBlocProvider<PlungerCubit, PlungerState>>()!;

    if (platformHelper.isMobile) {
      provider.add(
        PlungerAutoPullingBehavior(strength: pullingStrength),
      );
    } else {
      provider.addAll(
        [
          PlungerKeyControllingBehavior(),
          PlungerPullingBehavior(strength: pullingStrength),
        ],
      );
    }
  }

  void _removePlungerBehaviors(Plunger plunger) {
    plunger
        .descendants()
        .whereType<PlungerPullingBehavior>()
        .forEach(plunger.remove);
    plunger
        .descendants()
        .whereType<PlungerKeyControllingBehavior>()
        .forEach(plunger.remove);
  }

  void _addFlipperBehaviors(Flipper flipper) => flipper
    ..add(FlipperKeyControllingBehavior())
    ..moveDown();

  void _removeFlipperBehaviors(Flipper flipper) => flipper
      .descendants()
      .whereType<FlipperKeyControllingBehavior>()
      .forEach(flipper.remove);
}
