import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// Represents the [SignPost]'s current [Sprite] state.
@visibleForTesting
enum SignPostSpriteState {
  /// Signpost with no active dashes.
  inactive,

  /// Signpost with a single sign of active dashes.
  active1,

  /// Signpost with two signs of active dashes.
  active2,

  /// Signpost with all signs of active dashes.
  active3,
}

extension on SignPostSpriteState {
  String get path {
    switch (this) {
      case SignPostSpriteState.inactive:
        return Assets.images.signPost.inactive.keyName;
      case SignPostSpriteState.active1:
        return Assets.images.signPost.active1.keyName;
      case SignPostSpriteState.active2:
        return Assets.images.signPost.active2.keyName;
      case SignPostSpriteState.active3:
        return Assets.images.signPost.active3.keyName;
    }
  }

  SignPostSpriteState get next {
    return SignPostSpriteState
        .values[(index + 1) % SignPostSpriteState.values.length];
  }
}

/// {@template sign_post}
/// A sign, found in the Flutter Forest.
/// {@endtemplate}
class SignPost extends BodyComponent with InitialPosition {
  /// {@macro sign_post}
  SignPost()
      : super(
          priority: RenderPriority.signPost,
          children: [_SignPostSpriteComponent()],
        ) {
    renderBody = false;
  }

  /// Forwards the sprite to the next [SignPostSpriteState].
  ///
  /// If the current state is the last one it goes back to the initial state.
  void progress() => firstChild<_SignPostSpriteComponent>()!.progress();

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

class _SignPostSpriteComponent extends SpriteGroupComponent<SignPostSpriteState>
    with HasGameRef {
  _SignPostSpriteComponent()
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0.65, 0.45),
        );

  void progress() => current = current?.next;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = <SignPostSpriteState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SignPostSpriteState.values) {
      // TODO(allisonryan0002): Support caching
      // https://github.com/VGVentures/pinball/pull/204
      // sprites[spriteState] = Sprite(
      //   gameRef.images.fromCache(spriteState.path),
      // );
      sprites[spriteState] = await gameRef.loadSprite(spriteState.path);
    }

    current = SignPostSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
