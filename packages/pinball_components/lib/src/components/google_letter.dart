import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// Circular sensor that represents "Google" letter.
class GoogleLetter extends BodyComponent with InitialPosition {
  /// Circular sensor that represents the first letter "G" in "Google".
  GoogleLetter.letter1() : _sprite = _GoogleLetterSprite.letter1();

  /// Circular sensor that represents the first letter "O" in "Google".
  GoogleLetter.letter2() : _sprite = _GoogleLetterSprite.letter2();

  /// Circular sensor that represents the second letter "O" in "Google".
  GoogleLetter.letter3() : _sprite = _GoogleLetterSprite.letter3();

  /// Circular sensor that represents the letter "L" in "Google".
  GoogleLetter.letter4() : _sprite = _GoogleLetterSprite.letter4();

  /// Circular sensor that represents the  letter "E" in "Google".
  GoogleLetter.letter5() : _sprite = _GoogleLetterSprite.letter5();

  final _GoogleLetterSprite _sprite;

  /// Activates this [GoogleLetter].
  // TODO(alestiago): Improve doc comment once activate and deactivate
  // are implemented with the actual assets.
  Future<void> activate() async => _sprite.activate();

  /// Deactivates this [GoogleLetter].
  Future<void> deactivate() async => _sprite.deactivate();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_sprite);
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
  Future<void> activate() async {
    await add(
      _GoogleLetterColorEffect(color: Colors.green),
    );
  }

  Future<void> deactivate() async {
    await add(
      _GoogleLetterColorEffect(color: Colors.red),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(_spritePath);
    this.sprite = sprite;
    // TODO(alestiago): Size correctly once the assets are provided.
    size = sprite.originalSize / 5;
    anchor = Anchor.center;
  }
}

class _GoogleLetterColorEffect extends ColorEffect {
  _GoogleLetterColorEffect({
    required Color color,
  }) : super(
          color,
          const Offset(0, 1),
          EffectController(duration: 0.25),
        );
}
