import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// [PositionComponent] that shows the leaderboard while the player
/// has not started the game yet.
class BackboardWaiting extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardScores.keyName,
    );

    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.bottomCenter;
  }
}
