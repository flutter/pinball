import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template alien_bumper}
/// Bumper for Alien area.
/// {@endtemplate}
// TODO(ruimiguel): refactor later to unify with DashBumpers.
class AlienBumper extends BodyComponent with InitialPosition {
  /// {@macro alien_bumper}
  AlienBumper._({
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

  /// {@macro alien_bumper}
  AlienBumper.a()
      : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          activeAssetPath: Assets.images.alienBumper.a.active.keyName,
          inactiveAssetPath: Assets.images.alienBumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.1),
          ),
        );

  /// {@macro alien_bumper}
  AlienBumper.b()
      : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          activeAssetPath: Assets.images.alienBumper.b.active.keyName,
          inactiveAssetPath: Assets.images.alienBumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.1),
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
    renderBody = false;

    await _loadSprites();

    deactivate();
    await add(_spriteComponent);
  }

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(1.29);
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

  /// Activates the [AlienBumper].
  void activate() {
    _spriteComponent
      ..sprite = _activeSprite
      ..size = _activeSprite.originalSize / 10;
  }

  /// Deactivates the [AlienBumper].
  void deactivate() {
    _spriteComponent
      ..sprite = _inactiveSprite
      ..size = _inactiveSprite.originalSize / 10;
  }
}
