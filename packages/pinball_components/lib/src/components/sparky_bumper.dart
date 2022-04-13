import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_bumper}
/// Bumper for Sparky area.
/// {@endtemplate}
// TODO(ruimiguel): refactor later to unify with DashBumpers.
class SparkyBumper extends BodyComponent with InitialPosition {
  /// {@macro sparky_bumper}
  SparkyBumper._({
    required double majorRadius,
    required double minorRadius,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        _spriteComponent = spriteComponent;

  /// {@macro sparky_bumper}
  SparkyBumper.a()
      : this._(
          majorRadius: 2.9,
          minorRadius: 2.1,
          activeAssetPath: Assets.images.sparky.bumper.a.active.keyName,
          inactiveAssetPath: Assets.images.sparky.bumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.25),
          ),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.b()
      : this._(
          majorRadius: 2.85,
          minorRadius: 2,
          activeAssetPath: Assets.images.sparky.bumper.b.active.keyName,
          inactiveAssetPath: Assets.images.sparky.bumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.35),
          ),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.c()
      : this._(
          majorRadius: 3,
          minorRadius: 2.2,
          activeAssetPath: Assets.images.sparky.bumper.c.active.keyName,
          inactiveAssetPath: Assets.images.sparky.bumper.c.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.4),
          ),
        );

  final double _majorRadius;
  final double _minorRadius;
  final String _activeAssetPath;
  late final Sprite _activeSprite;
  final String _inactiveAssetPath;
  late final Sprite _inactiveSprite;
  final SpriteComponent _spriteComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();

    // TODO(erickzanardo): Look into using onNewState instead.
    // Currently doing: onNewState(gameRef.read<GameState>()) will throw an
    // `Exception: build context is not available yet`
    deactivate();
    await add(_spriteComponent);
  }

  @override
  Body createBody() {
    renderBody = false;

    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(math.pi / 2.1);
    final fixtureDef = FixtureDef(shape)
      ..friction = 0
      ..restitution = 4;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  Future<void> _loadSprites() async {
    // TODO(alestiago): I think ideally we would like to do:
    // Sprite(path).load so we don't require to store the activeAssetPath and
    // the inactive assetPath.
    _inactiveSprite = await gameRef.loadSprite(_inactiveAssetPath);
    _activeSprite = await gameRef.loadSprite(_activeAssetPath);
  }

  /// Activates the [DashNestBumper].
  void activate() {
    _spriteComponent
      ..sprite = _activeSprite
      ..size = _activeSprite.originalSize / 10;
  }

  /// Deactivates the [DashNestBumper].
  void deactivate() {
    _spriteComponent
      ..sprite = _inactiveSprite
      ..size = _inactiveSprite.originalSize / 10;
  }
}
