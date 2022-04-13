import 'package:flame/components.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template rocket_sprite_component}
/// A [SpriteComponent] for the rocket over [Plunger].
/// {@endtemplate}
class RocketSpriteComponent extends SpriteComponent with HasGameRef {
  // TODO(ruimiguel): change this priority to be over launcher ramp and bottom
  // wall.
  /// {@macro rocket_sprite_component}
  RocketSpriteComponent() : super(priority: 5);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.plunger.rocket.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}
