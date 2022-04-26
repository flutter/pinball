import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_letter/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/google_letter_cubit.dart';

/// {@template google_letter}
/// Circular sensor that represents a letter in "GOOGLE" for a given index.
/// {@endtemplate}
class GoogleLetter extends BodyComponent with InitialPosition {
  /// {@macro google_letter}
  GoogleLetter(
    int index, {
    GoogleLetterCubit? bloc,
  })  : bloc = bloc ?? GoogleLetterCubit(),
        super(
          children: [
            GoogleLetterBallContactBehavior(),
            _GoogleLetterSprite(_GoogleLetterSprite.spritePaths[index])
          ],
        );

  final GoogleLetterCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
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

class _GoogleLetterSprite extends SpriteComponent
    with HasGameRef, ParentIsA<GoogleLetter> {
  _GoogleLetterSprite(String path)
      : _path = path,
        super(anchor: Anchor.center);

  static final spritePaths = [
    Assets.images.googleWord.letter1.keyName,
    Assets.images.googleWord.letter2.keyName,
    Assets.images.googleWord.letter3.keyName,
    Assets.images.googleWord.letter4.keyName,
    Assets.images.googleWord.letter5.keyName,
    Assets.images.googleWord.letter6.keyName,
  ];

  final String _path;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alisonryan2002): Make SpriteGroupComponent.
    // parent.bloc.stream.listen();

    // TODO(alestiago): Used cached assets.
    final sprite = await gameRef.loadSprite(_path);
    this.sprite = sprite;
    // TODO(alestiago): Size correctly once the assets are provided.
    size = sprite.originalSize / 5;
  }
}
