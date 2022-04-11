import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

class GoogleLetter extends BodyComponent with InitialPosition {
  late final _GoogleLetterSprite _sprite;

  void activate() => _sprite.activate();

  void deactivate() => _sprite.deactivate();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_sprite = _GoogleLetterSprite.letter1());
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1.85;
    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _GoogleLetterSprite extends SpriteComponent with HasGameRef {
  _GoogleLetterSprite.letter1()
      : _spritePath = Assets.images.googleWord.letter1.keyName;

  _GoogleLetterSprite.letter2()
      : _spritePath = Assets.images.googleWord.letter2.keyName;

  _GoogleLetterSprite.letter3()
      : _spritePath = Assets.images.googleWord.letter3.keyName;

  _GoogleLetterSprite.letter4()
      : _spritePath = Assets.images.googleWord.letter4.keyName;

  _GoogleLetterSprite.letter5()
      : _spritePath = Assets.images.googleWord.letter5.keyName;

  final String _spritePath;

  // TODO(alestiago): Correctly implement activate and deactivate once the
  // assets are provided.
  void activate() {
    tint(Colors.green);
  }

  void deactivate() {
    tint(Colors.red);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(_spritePath);
    this.sprite = sprite;
    size = sprite.originalSize / 5;
    anchor = Anchor.center;
  }
}
