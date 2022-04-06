import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_bumper}
/// Bumper for Sparky fire.
/// {@endtemplate}
// TODO(ruimiguel): refactor later to unify with DashBumpers.
class SparkyBumper extends BodyComponent with InitialPosition {
  /// {@macro sparky_bumper}
  SparkyBumper._({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        _spriteComponent = spriteComponent;

  /// {@macro sparky_bumper}
  SparkyBumper.a()
      : this._(
          activeAssetPath: Assets.images.sparkyBumper.a.active.keyName,
          inactiveAssetPath: Assets.images.sparkyBumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.2),
          ),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.b()
      : this._(
          activeAssetPath: Assets.images.sparkyBumper.b.active.keyName,
          inactiveAssetPath: Assets.images.sparkyBumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.1, -0.2),
          ),
        );

  /// {@macro sparky_bumper}
  SparkyBumper.c()
      : this._(
          activeAssetPath: Assets.images.sparkyBumper.c.active.keyName,
          inactiveAssetPath: Assets.images.sparkyBumper.c.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.2, -0.5),
          ),
        );

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
      majorRadius: 2.85,
      minorRadius: 2.15,
    )..rotate(math.pi / 2);
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
