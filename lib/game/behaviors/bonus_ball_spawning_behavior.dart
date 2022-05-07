import 'package:flame/components.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template bonus_ball_spawning_behavior}
/// After a duration, spawns a bonus ball from the [DinoWalls] and boosts it
/// into the middle of the board.
/// {@endtemplate}
class BonusBallSpawningBehavior extends TimerComponent with HasGameRef {
  /// {@macro bonus_ball_spawning_behavior}
  BonusBallSpawningBehavior()
      : super(
          period: 5,
          removeOnFinish: true,
        );

  @override
  void onTick() {
    final characterTheme = readBloc<CharacterThemeCubit, CharacterThemeState>()
        .state
        .characterTheme;
    gameRef.descendants().whereType<ZCanvasComponent>().single.add(
          Ball(assetPath: characterTheme.ball.keyName)
            ..add(BallImpulsingBehavior(impulse: Vector2(-40, 0)))
            ..initialPosition = Vector2(29.2, -24.5)
            ..zIndex = ZIndexes.ballOnBoard,
        );
  }
}
