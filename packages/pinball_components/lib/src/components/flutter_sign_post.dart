import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flutter_sign_post}
/// A sign, found in the Flutter Forest.
/// {@endtemplate}
class FlutterSignPost extends BodyComponent with InitialPosition {
  /// {@macro flutter_sign_post}
  FlutterSignPost()
      : super(
          priority: RenderPriority.flutterSignPost,
          children: [_FlutterSignPostSpriteComponent()],
        ) {
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.25;
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _FlutterSignPostSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.flutterSignPost.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.bottomCenter;
    position = Vector2(0.65, 0.45);
  }
}
