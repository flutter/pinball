import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
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
    if (state.isGameOver) {
      gameOver();
    } else {
      start();
    }
  }

  /// Puts the game on a game over state
  void gameOver() {
    // TODO(erickzanardo): implement score submission and "navigate" to the
    // next page
    component.firstChild<Backboard>()?.gameOverMode(
          score: state?.score ?? 0,
          characterIconPath:
              component.theme.characterTheme.leaderboardIcon.keyName,
        );
    component.firstChild<CameraController>()?.focusOnBackboard();
  }

  /// Puts the game on a playing state
  void start() {
    component.firstChild<Backboard>()?.waitingMode();
    component.firstChild<CameraController>()?.focusOnGame();
    component.overlays.remove(PinballGame.playButtonOverlay);
  }
}
