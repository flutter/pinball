import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard}
/// The [Backboard] of the pinball machine.
/// {@endtemplate}
class Backboard extends PositionComponent with HasGameRef {
  /// {@macro backboard}
  Backboard({
    required Vector2 position,
    this.startsAtWaiting = true,
  }) : super(
          // TODO(erickzanardo): remove multiply after
          // https://github.com/flame-engine/flame/pull/1506 is merged
          position: position..clone().multiply(Vector2(1, -1)),
          anchor: Anchor.bottomCenter,
        );

  /// If true will start at the waiting mode
  final bool startsAtWaiting;

  @override
  Future<void> onLoad() async {
    if (startsAtWaiting) {
      await waitingMode();
    } else {
      await gameOverMode();
    }
  }

  /// Puts the Backboard in waiting mode, where the scoreboard is shown.
  Future<void> waitingMode() async {
    children.removeWhere((element) => true);
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardScores.keyName,
    );
    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.bottomCenter,
      ),
    );
  }

  /// Puts the Backboard in game over mode, where the score input is shown.
  Future<void> gameOverMode() async {
    children.removeWhere((element) => true);
    await add(BackboardGameOver());
  }
}

/// {@template backboard_game_over}
class BackboardGameOver extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardGameOver.keyName,
    );
    size = sprite.originalSize / 10;
    anchor = Anchor.bottomCenter;
    this.sprite = sprite;
  }
}
