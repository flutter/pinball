import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Updates the launch [Ball] to reflect character selections.
class BallThemingBehavior extends Component
    with
        FlameBlocListenable<CharacterThemeCubit, CharacterThemeState>,
        HasGameRef {
  @override
  void onNewState(CharacterThemeState state) {
    final ballsInGame = gameRef.descendants().whereType<Ball>();
    if (ballsInGame.isNotEmpty) {
      gameRef.removeAll(ballsInGame);
    }
    final plunger = gameRef.descendants().whereType<Plunger>().single;
    final canvas = gameRef.descendants().whereType<ZCanvasComponent>().single;
    final ball = ControlledBall.launch(characterTheme: state.characterTheme)
      ..initialPosition = Vector2(
        plunger.body.position.x,
        plunger.body.position.y - Ball.size.y + 1.1,
      );

    canvas.add(ball);
  }
}
