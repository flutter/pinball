import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template alien_bumper}
/// Bumper for area under the [Spaceship].
/// {@endtemplate}
class AlienBumper extends BodyComponent with InitialPosition {
  /// {@macro alien_bumper}
  AlienBumper._({
    required double majorRadius,
    required double minorRadius,
    required String onAssetPath,
    required String offAssetPath,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          children: [
            _AlienBumperSpriteGroupComponent(
              onAssetPath: onAssetPath,
              offAssetPath: offAssetPath,
            ),
          ],
        ) {
    renderBody = false;
  }

  /// {@macro alien_bumper}
  AlienBumper.a()
      : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          onAssetPath: Assets.images.alienBumper.a.on.keyName,
          offAssetPath: Assets.images.alienBumper.a.off.keyName,
        );

  /// {@macro alien_bumper}
  AlienBumper.b()
      : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          onAssetPath: Assets.images.alienBumper.b.on.keyName,
          offAssetPath: Assets.images.alienBumper.b.off.keyName,
        );

  final double _majorRadius;
  final double _minorRadius;

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(1.29);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 4,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Animates the [AlienBumper].
  Future<void> animate() async {
    final spriteGroupComponent = firstChild<_AlienBumperSpriteGroupComponent>()
      ?..current = AlienBumperSpriteState.off;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    spriteGroupComponent?.current = AlienBumperSpriteState.on;
  }
}

@visibleForTesting

/// Indicates the [AlienBumper]'s current sprite state.
enum AlienBumperSpriteState {
  /// The on sprite is being displayed.
  on,

  /// The off sprite is being displayed.
  off,
}

class _AlienBumperSpriteGroupComponent
    extends SpriteGroupComponent<AlienBumperSpriteState> with HasGameRef {
  _AlienBumperSpriteGroupComponent({
    required String onAssetPath,
    required String offAssetPath,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: Vector2(0, -0.1),
        );

  final String _onAssetPath;
  final String _offAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = {
      AlienBumperSpriteState.on: Sprite(gameRef.images.fromCache(_onAssetPath)),
      AlienBumperSpriteState.off:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };

    this.sprites = sprites;
    size = sprites[AlienBumperSpriteState.on]!.originalSize / 10;

    current = AlienBumperSpriteState.on;
  }
}
