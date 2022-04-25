import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template google_letter}
/// Circular sensor that represents a letter in "GOOGLE" for a given index.
/// {@endtemplate}
class GoogleLetter extends BodyComponent with InitialPosition {
  /// {@macro google_letter}
  GoogleLetter(int index)
      : _sprite = _GoogleLetterSprite(
          _GoogleLetterSprite.spritePaths[index],
        );

  final _GoogleLetterSprite _sprite;

  /// Activates this [GoogleLetter].
  // TODO(alestiago): Improve doc comment once activate and deactivate
  // are implemented with the actual assets.
  Future<void> activate() => _sprite.activate();

  /// Deactivates this [GoogleLetter].
  Future<void> deactivate() => _sprite.deactivate();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_sprite);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1.85;
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _GoogleLetterSprite extends SpriteComponent with HasGameRef {
  _GoogleLetterSprite(String path) : _path = path;

  static final spritePaths = [
    Assets.images.googleWord.letter1.keyName,
    Assets.images.googleWord.letter2.keyName,
    Assets.images.googleWord.letter3.keyName,
    Assets.images.googleWord.letter4.keyName,
    Assets.images.googleWord.letter5.keyName,
    Assets.images.googleWord.letter6.keyName,
  ];

  final String _path;

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

    // TODO(alestiago): Used cached assets.
    final sprite = await gameRef.loadSprite(_path);
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
