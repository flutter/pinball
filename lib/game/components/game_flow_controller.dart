import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

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
    component.firstChild<Backboard>()?.gameOverMode();
    component.firstChild<CameraController>()?.focusOnBackboard();
  }

  /// Puts the game on a playing state
  void start() {
    component.firstChild<Backboard>()?.waitingMode();
    component.firstChild<CameraController>()?.focusOnGame();
    component.overlays.remove(PinballGame.playButtonOverlay);
  }
}
