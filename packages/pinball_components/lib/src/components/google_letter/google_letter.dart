import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_letter/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/google_letter_cubit.dart';

final _spritePaths = <Map<GoogleLetterState, String>>[
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter1.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter1.dimmed.keyName,
  },
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter2.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter2.dimmed.keyName,
  },
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter3.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter3.dimmed.keyName,
  },
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter4.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter4.dimmed.keyName,
  },
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter5.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter5.dimmed.keyName,
  },
  {
    GoogleLetterState.lit: Assets.images.googleWord.letter6.lit.keyName,
    GoogleLetterState.dimmed: Assets.images.googleWord.letter6.dimmed.keyName,
  },
];

/// {@template google_letter}
/// Circular sensor that represents a letter in "GOOGLE" for a given index.
/// {@endtemplate}
class GoogleLetter extends BodyComponent with InitialPosition {
  /// {@macro google_letter}
  GoogleLetter(
    int index, {
    Iterable<Component>? children,
  }) : this._(
          index,
          bloc: GoogleLetterCubit(),
          children: children,
        );

  GoogleLetter._(
    int index, {
    required this.bloc,
    Iterable<Component>? children,
  }) : super(
          children: [
            _GoogleLetterSpriteGroupComponent(
              litAssetPath: _spritePaths[index][GoogleLetterState.lit]!,
              dimmedAssetPath: _spritePaths[index][GoogleLetterState.dimmed]!,
              current: bloc.state,
            ),
            GoogleLetterBallContactBehavior(),
            ...?children,
          ],
          renderBody: false,
        );

  /// Creates a [GoogleLetter] without any children.
  ///
  /// This can be used for testing [GoogleLetter]'s behaviors in isolation.
  @visibleForTesting
  GoogleLetter.test({
    required this.bloc,
  });

  // ignore: public_member_api_docs
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

class _GoogleLetterSpriteGroupComponent
    extends SpriteGroupComponent<GoogleLetterState>
    with HasGameRef, ParentIsA<GoogleLetter> {
  _GoogleLetterSpriteGroupComponent({
    required String litAssetPath,
    required String dimmedAssetPath,
    required GoogleLetterState current,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        super(
          anchor: Anchor.center,
          current: current,
        );

  final String _litAssetPath;
  final String _dimmedAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      GoogleLetterState.lit: Sprite(
        gameRef.images.fromCache(_litAssetPath),
      ),
      GoogleLetterState.dimmed: Sprite(
        gameRef.images.fromCache(_dimmedAssetPath),
      ),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
