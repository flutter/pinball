// ignore_for_file: public_member_api_docs

import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

class BoardBackgroundSpriteComponent extends SpriteComponent with HasGameRef {
  BoardBackgroundSpriteComponent()
      : super(
          anchor: Anchor.center,
          priority: RenderPriority.boardBackground,
          position: Vector2(0, -1),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.boardBackground.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
