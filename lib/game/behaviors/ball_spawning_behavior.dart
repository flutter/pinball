import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Spawns a new [Ball] into the game when all balls are lost and still
/// [GameStatus.playing].
class BallSpawningBehavior extends Component
    with FlameBlocListenable<GameBloc, GameState>, HasGameRef {
  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    if (!newState.status.isPlaying) return false;

    final startedGame = (previousState?.status.isWaiting ?? true) ||
        (previousState?.status.isGameOver ?? true);
    final lostRound =
        (previousState?.rounds ?? newState.rounds + 1) > newState.rounds;
    return startedGame || lostRound;
  }

  @override
  void onNewState(GameState state) {
    final plunger = gameRef.descendants().whereType<Plunger>().single;
    final canvas = gameRef.descendants().whereType<ZCanvasComponent>().single;
    final characterTheme = readBloc<CharacterThemeCubit, CharacterThemeState>()
        .state
        .characterTheme;
    final ball = Ball(assetPath: characterTheme.ball.keyName)
      ..initialPosition = Vector2(
        plunger.body.position.x,
        plunger.body.position.y - Ball.size.y,
      )
      ..layer = Layer.launcher
      ..zIndex = ZIndexes.ballOnLaunchRamp;

    canvas.add(ball);
  }
}
