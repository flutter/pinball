import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard}
/// The [Backboard] of the pinball machine.
/// {@endtemplate}
class Backboard extends SpriteComponent with HasGameRef {
  /// {@macro backboard}
  Backboard({
    required Vector2 position,
  }) : super(
          // TODO(erickzanardo): remove multiply after
          // https://github.com/flame-engine/flame/pull/1506 is merged
          position: position..clone().multiply(Vector2(1, -1)),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await waitingMode();
  }

  /// Puts the Backboard in waiting mode, where the scoreboard is shown.
  Future<void> waitingMode() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardScores.keyName,
    );
    size = sprite.originalSize / 10;
    this.sprite = sprite;
  }

  /// Puts the Backboard in game over mode, where the score input is shown.
  Future<void> gameOverMode() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardGameOver.keyName,
    );
    size = sprite.originalSize / 10;
    this.sprite = sprite;
  }
}
