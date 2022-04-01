import 'package:flame/components.dart';
import 'package:pinball_components/gen/assets.gen.dart';

/// {@template panel}
/// The vertical panel of the pinball
/// {@endtemplate}
class Panel extends SpriteComponent with HasGameRef {
  ///{@macro panel}
  Panel({
    required Vector2 position,
  }) : super(
          // TODO(erickzanardo): https://github.com/flame-engine/flame/issues/1132
          position: position
            ..clone().multiply(
              Vector2(1, -1),
            ),
          size: Vector2(80, 60),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Assets.images.panel.keyName);
  }
}
