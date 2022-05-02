import 'package:flame/components.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template rocket_sprite_component}
/// A [SpriteComponent] for the rocket over [Plunger].
/// {@endtemplate}
class RocketSpriteComponent extends SpriteComponent with HasGameRef, ZIndex {
  /// {@macro rocket_sprite_component}
  RocketSpriteComponent() : super(anchor: Anchor.center) {
    zIndex = ZIndexes.rocket;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.plunger.rocket.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
