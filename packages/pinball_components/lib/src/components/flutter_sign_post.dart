import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flutter_sign_post}
/// A sign, found in the FlutterForest.
/// {@endtemplate}
// TODO(alestiago): Revisit doc comment if FlutterForest is moved to package.
class FlutterSignPost extends BodyComponent with InitialPosition {
  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.flutterSignPost.keyName,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: sprite.originalSize / 10,
      anchor: Anchor.bottomCenter,
      position: Vector2(0.65, 0.45),
    );
    await add(spriteComponent);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    await _loadSprite();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.25;
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef()..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
