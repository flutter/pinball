import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template bumper}
/// Generic bumper.
/// {@endtemplate}
abstract class Bumper extends BodyComponent with InitialPosition {
  /// {@macro bumper}
  Bumper({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        _spriteComponent = spriteComponent;

  final String _activeAssetPath;
  late final Sprite _activeSprite;
  final String _inactiveAssetPath;
  late final Sprite _inactiveSprite;
  final SpriteComponent _spriteComponent;

  Future<void> _loadSprites() async {
    // TODO(alestiago): I think ideally we would like to do:
    // Sprite(path).load so we don't require to store the activeAssetPath and
    // the inactive assetPath.
    _inactiveSprite = await gameRef.loadSprite(_inactiveAssetPath);
    _activeSprite = await gameRef.loadSprite(_activeAssetPath);
  }

  /// Activates the [Bumper].
  void activate() {
    _spriteComponent
      ..sprite = _activeSprite
      ..size = _activeSprite.originalSize / 10;
  }

  /// Deactivates the [Bumper].
  void deactivate() {
    _spriteComponent
      ..sprite = _inactiveSprite
      ..size = _inactiveSprite.originalSize / 10;
  }

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
}
