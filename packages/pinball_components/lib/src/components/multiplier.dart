import 'package:flame/components.dart';

/// Indicates the current sprite state of the multiplier.
enum MultiplierSpriteState {
  /// A lit up bumper.
  active,

  /// A dimmed bumper.
  inactive,
}

/// {@template multiplier_sprite_group_component}
/// A [SpriteGroupComponent] for the multiplier over the board.
/// {@endtemplate}
class MultiplierSpriteGroupComponent
    extends SpriteGroupComponent<MultiplierSpriteState> with HasGameRef {
  /// {@macro multiplier_sprite_group_component}
  MultiplierSpriteGroupComponent({
    required Vector2 position,
    required String onAssetPath,
    required String offAssetPath,
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
      MultiplierSpriteState.active:
          Sprite(gameRef.images.fromCache(_onAssetPath)),
      MultiplierSpriteState.inactive:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };
    this.sprites = sprites;

    current = MultiplierSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
