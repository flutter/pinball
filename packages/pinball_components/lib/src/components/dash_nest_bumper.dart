import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template dash_nest_bumper}
/// Bumper with a nest appearance.
/// {@endtemplate}
class DashNestBumper extends BodyComponent with InitialPosition {
  /// {@macro dash_nest_bumper}
  DashNestBumper._({
    required double majorRadius,
    required double minorRadius,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 spritePosition,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.dashBumper,
          children: [
            _DashNestBumperSpriteGroupComponent(
              activeAssetPath: activeAssetPath,
              inactiveAssetPath: inactiveAssetPath,
              position: spritePosition,
            ),
          ],
        ) {
    renderBody = false;
  }

  /// {@macro dash_nest_bumper}
  DashNestBumper.main()
      : this._(
          majorRadius: 5.1,
          minorRadius: 3.75,
          activeAssetPath: Assets.images.dash.bumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.main.inactive.keyName,
          spritePosition: Vector2(0, -0.3),
        );

  /// {@macro dash_nest_bumper}
  DashNestBumper.a()
      : this._(
          majorRadius: 3,
          minorRadius: 2.5,
          activeAssetPath: Assets.images.dash.bumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.a.inactive.keyName,
          spritePosition: Vector2(0.35, -1.2),
        );

  /// {@macro dash_nest_bumper}
  DashNestBumper.b()
      : this._(
          majorRadius: 3,
          minorRadius: 2.5,
          activeAssetPath: Assets.images.dash.bumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.b.inactive.keyName,
          spritePosition: Vector2(0.35, -1.2),
        );

  final double _majorRadius;
  final double _minorRadius;

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(math.pi / 1.9);
    final fixtureDef = FixtureDef(shape, restitution: 4);
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Activates the [DashNestBumper].
  void activate() {
    firstChild<_DashNestBumperSpriteGroupComponent>()?.current =
        DashNestBumperSpriteState.active;
  }

  /// Deactivates the [DashNestBumper].
  void deactivate() {
    firstChild<_DashNestBumperSpriteGroupComponent>()?.current =
        DashNestBumperSpriteState.inactive;
  }
}

/// Indicates the [DashNestBumper]'s current sprite state.
@visibleForTesting
enum DashNestBumperSpriteState {
  /// A lit up bumper.
  active,

  /// A dimmed bumper.
  inactive,
}

class _DashNestBumperSpriteGroupComponent
    extends SpriteGroupComponent<DashNestBumperSpriteState> with HasGameRef {
  _DashNestBumperSpriteGroupComponent({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 position,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
        );

  final String _activeAssetPath;
  final String _inactiveAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = {
      DashNestBumperSpriteState.active:
          Sprite(gameRef.images.fromCache(_activeAssetPath)),
      DashNestBumperSpriteState.inactive:
          Sprite(gameRef.images.fromCache(_inactiveAssetPath)),
    };
    this.sprites = sprites;

    current = DashNestBumperSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
