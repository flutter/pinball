import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_bumper}
/// Bumper for Sparky area.
/// {@endtemplate}
class SparkyBumper extends BodyComponent with InitialPosition {
  /// {@macro sparky_bumper}
  SparkyBumper._({
    required double majorRadius,
    required double minorRadius,
    required String onAssetPath,
    required String offAssetPath,
    required Vector2 spritePosition,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.sparkyBumper,
          children: [
            _SparkyBumperSpriteGroupComponent(
              onAssetPath: onAssetPath,
              offAssetPath: offAssetPath,
              position: spritePosition,
            ),
          ],
        ) {
    renderBody = false;
  }

  /// {@macro sparky_bumper}
  SparkyBumper.a()
      : this._(
          majorRadius: 2.9,
          minorRadius: 2.1,
          onAssetPath: Assets.images.sparky.bumper.a.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.a.inactive.keyName,
          spritePosition: Vector2(0, -0.25),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.b()
      : this._(
          majorRadius: 2.85,
          minorRadius: 2,
          onAssetPath: Assets.images.sparky.bumper.b.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.b.inactive.keyName,
          spritePosition: Vector2(0, -0.35),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.c()
      : this._(
          majorRadius: 3,
          minorRadius: 2.2,
          onAssetPath: Assets.images.sparky.bumper.c.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.c.inactive.keyName,
          spritePosition: Vector2(0, -0.4),
        );

  final double _majorRadius;
  final double _minorRadius;

  @override
  Body createBody() {
    renderBody = false;

    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(math.pi / 2.1);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 4,
    );
    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Animates the [DashNestBumper].
  Future<void> animate() async {
    final spriteGroupComponent = firstChild<_SparkyBumperSpriteGroupComponent>()
      ?..current = SparkyBumperSpriteState.inactive;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    spriteGroupComponent?.current = SparkyBumperSpriteState.active;
  }
}

/// Indicates the [SparkyBumper]'s current sprite state.
@visibleForTesting
enum SparkyBumperSpriteState {
  /// A lit up bumper.
  active,

  /// A dimmed bumper.
  inactive,
}

class _SparkyBumperSpriteGroupComponent
    extends SpriteGroupComponent<SparkyBumperSpriteState> with HasGameRef {
  _SparkyBumperSpriteGroupComponent({
    required String onAssetPath,
    required String offAssetPath,
    required Vector2 position,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
        );

  final String _onAssetPath;
  final String _offAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = {
      SparkyBumperSpriteState.active:
          Sprite(gameRef.images.fromCache(_onAssetPath)),
      SparkyBumperSpriteState.inactive:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };
    this.sprites = sprites;

    current = SparkyBumperSpriteState.active;
    size = sprites[current]!.originalSize / 10;
  }
}
