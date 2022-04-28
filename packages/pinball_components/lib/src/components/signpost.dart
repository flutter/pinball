import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// Represents the [Signpost]'s current [Sprite] state.
@visibleForTesting
enum SignpostSpriteState {
  /// Signpost with no active dashes.
  inactive,

  /// Signpost with a single sign of active dashes.
  active1,

  /// Signpost with two signs of active dashes.
  active2,

  /// Signpost with all signs of active dashes.
  active3,
}

extension on SignpostSpriteState {
  String get path {
    switch (this) {
      case SignpostSpriteState.inactive:
        return Assets.images.signpost.inactive.keyName;
      case SignpostSpriteState.active1:
        return Assets.images.signpost.active1.keyName;
      case SignpostSpriteState.active2:
        return Assets.images.signpost.active2.keyName;
      case SignpostSpriteState.active3:
        return Assets.images.signpost.active3.keyName;
    }
  }

  SignpostSpriteState get next {
    return SignpostSpriteState
        .values[(index + 1) % SignpostSpriteState.values.length];
  }
}

/// {@template signpost}
/// A sign, found in the Flutter Forest.
///
/// Lights up a new sign whenever all three [DashNestBumper]s are hit.
/// {@endtemplate}
class Signpost extends BodyComponent with InitialPosition {
  /// {@macro signpost}
  Signpost({
    Iterable<Component>? children,
  }) : super(
          renderBody: false,
          children: [
            _SignpostSpriteComponent(),
            ...?children,
          ],
        );

  /// Forwards the sprite to the next [SignpostSpriteState].
  ///
  /// If the current state is the last one it cycles back to the initial state.
  void progress() => firstChild<_SignpostSpriteComponent>()!.progress();

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

class _SignpostSpriteComponent extends SpriteGroupComponent<SignpostSpriteState>
    with HasGameRef {
  _SignpostSpriteComponent()
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0.65, 0.45),
        );

  void progress() => current = current?.next;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = <SignpostSpriteState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SignpostSpriteState.values) {
      sprites[spriteState] = Sprite(
        gameRef.images.fromCache(spriteState.path),
      );
    }

    current = SignpostSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
