import 'package:flame/components.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball/gen/assets.gen.dart';

class Background extends Component with HasGameRef<PinballGame> {
  static final Vector2 size = Vector2(120, 160);

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.components.background.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
    )..position = Vector2(0, -7.8);

    await add(spriteComponent);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
    priority = -1;
  }
}
