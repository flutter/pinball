import 'package:flame/components.dart';
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
              activeAssetPath: _GoogleLetterSpriteGroupComponent
                  .spritePaths[index][GoogleLetterState.active]!,
              inactiveAssetPath: _GoogleLetterSpriteGroupComponent
                  .spritePaths[index][GoogleLetterState.inactive]!,
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
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  GoogleLetter.test({
    required this.bloc,
  });

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
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
    required String activeAssetPath,
    required String inactiveAssetPath,
    required GoogleLetterState current,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        super(
          anchor: Anchor.center,
          current: current,
        );

  final String _activeAssetPath;
  final String _inactiveAssetPath;

  static final spritePaths = <Map<GoogleLetterState, String>>[
    {
      GoogleLetterState.active: Assets.images.googleWord.letter1.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter1.inactive.keyName,
    },
    {
      GoogleLetterState.active: Assets.images.googleWord.letter2.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter2.inactive.keyName,
    },
    {
      GoogleLetterState.active: Assets.images.googleWord.letter3.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter3.inactive.keyName,
    },
    {
      GoogleLetterState.active: Assets.images.googleWord.letter4.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter4.inactive.keyName,
    },
    {
      GoogleLetterState.active: Assets.images.googleWord.letter5.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter5.inactive.keyName,
    },
    {
      GoogleLetterState.active: Assets.images.googleWord.letter6.active.keyName,
      GoogleLetterState.inactive:
          Assets.images.googleWord.letter6.inactive.keyName,
    },
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      GoogleLetterState.active: Sprite(
        gameRef.images.fromCache(_activeAssetPath),
      ),
      GoogleLetterState.inactive: Sprite(
        gameRef.images.fromCache(_inactiveAssetPath),
      ),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
