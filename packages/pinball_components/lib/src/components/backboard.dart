import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard}
/// The [Backboard] of the pinball machine
/// {@endtemplate}
class Backboard extends SpriteComponent with HasGameRef {
  /// {@macro backboard}
  Backboard({
    required Vector2 position,
  }) : super(
          position: position..clone().multiply(Vector2(1, -1)),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await waitingMode();
  }

  /// Sets the Backboard on the waiting mode, where the scoreboard is show
  Future<void> waitingMode() async {
    size = Vector2(120, 100);
    sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardScores.keyName,
    );
  }

  /// Sets the Backboard on the game over mode, where the score input is show
  Future<void> gameOverMode() async {
    size = Vector2(100, 100);
    sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardGameOver.keyName,
    );
  }
}
