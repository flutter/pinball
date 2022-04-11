import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

enum GoogleLetterOrder {
  first,
  second,
  third,
  fourth,
  fifth,
}

extension on GoogleLetterOrder {
  String get path {
    switch (this) {
      case GoogleLetterOrder.first:
        return Assets.images.googleWord.letter1.keyName;
      case GoogleLetterOrder.second:
        return Assets.images.googleWord.letter2.keyName;
      case GoogleLetterOrder.third:
        return Assets.images.googleWord.letter3.keyName;
      case GoogleLetterOrder.fourth:
        return Assets.images.googleWord.letter4.keyName;
      case GoogleLetterOrder.fifth:
        return Assets.images.googleWord.letter5.keyName;
    }
  }
}

/// {@template google_letter}
/// Circular sensor that represents "Google" letter.
/// {@endtemplate}
class GoogleLetter extends BodyComponent with InitialPosition {
  /// {@macro google_letter}
  GoogleLetter(GoogleLetterOrder order)
      : _sprite = _GoogleLetterSprite(order.path);

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
  _GoogleLetterSprite(String path) : _path = path;

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
