import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template google_letter}
/// Circular sensor that represents a letter in "GOOGLE" for a given index.
/// {@endtemplate}
class GoogleLetter extends BodyComponent with InitialPosition {
  /// {@macro google_letter}
  GoogleLetter(int index)
      : _sprite = _GoogleLetterSpriteGroupComponent(
          _GoogleLetterSpriteGroupComponent.spritePaths[index],
        );

  final _GoogleLetterSpriteGroupComponent _sprite;

  /// Displays active sprite for this [GoogleLetter].
  void activate() => _sprite.activate();

  /// Displays inactive sprite for this [GoogleLetter].
  void deactivate() => _sprite.deactivate();

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

/// Indicates the [GoogleLetter]'s current sprite state.
@visibleForTesting
enum GoogleLetterSpriteState {
  /// A lit up letter.
  active,

  /// A dimmed letter.
  inactive,
}

class _GoogleLetterSpriteGroupComponent
    extends SpriteGroupComponent<GoogleLetterSpriteState> with HasGameRef {
  _GoogleLetterSpriteGroupComponent(
    Map<GoogleLetterSpriteState, String> statePaths,
  )   : _statePaths = statePaths,
        super(anchor: Anchor.center);

  static final spritePaths = <Map<GoogleLetterSpriteState, String>>[
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter1.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter1.inactive.keyName,
    },
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter2.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter2.inactive.keyName,
    },
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter3.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter3.inactive.keyName,
    },
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter4.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter4.inactive.keyName,
    },
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter5.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter5.inactive.keyName,
    },
    {
      GoogleLetterSpriteState.active:
          Assets.images.googleWord.letter6.active.keyName,
      GoogleLetterSpriteState.inactive:
          Assets.images.googleWord.letter6.inactive.keyName,
    },
  ];

  final Map<GoogleLetterSpriteState, String> _statePaths;

  void activate() {
    current = GoogleLetterSpriteState.active;
  }

  void deactivate() {
    current = GoogleLetterSpriteState.inactive;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    paint = Paint()..isAntiAlias = false;

    final sprites = {
      GoogleLetterSpriteState.active: Sprite(
        gameRef.images.fromCache(_statePaths[GoogleLetterSpriteState.active]!),
      ),
      GoogleLetterSpriteState.inactive: Sprite(
        gameRef.images
            .fromCache(_statePaths[GoogleLetterSpriteState.inactive]!),
      ),
    };
    this.sprites = sprites;

    current = GoogleLetterSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
