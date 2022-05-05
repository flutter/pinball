import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template game_flow_controller}
/// A [Component] that controls the game over and game restart logic
/// {@endtemplate}
class GameFlowController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  /// {@macro game_flow_controller}
  GameFlowController(PinballGame component) : super(component);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.isGameOver != newState.isGameOver;
  }

  @override
  void onNewState(GameState state) {
    print("START $state");
    if (state.isGameOver) {
      _initialsInput();
    } else {
      start();
    }
  }

  /// Puts the game in the initials input state.
  void _initialsInput() {
    // TODO(erickzanardo): implement score submission and "navigate" to the
    // next page
    component.descendants().whereType<Backbox>().first.infoScreen(
          score: state?.displayScore ?? 0,
          characterIconPath: component.characterTheme.leaderboardIcon.keyName,
        );
    component.firstChild<CameraController>()!.focusOnGameOverBackbox();
  }

  /// Puts the game in the playing state.
  void start() {
    _initialsInput();
    /*
    component.audio.backgroundMusic();
    component.firstChild<CameraController>()?.focusOnGame();
    component.overlays.remove(PinballGame.playButtonOverlay);*/
  }
}
