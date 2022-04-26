import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';

/// {@template multiball}
/// A [Component] for the multiball over the board.
/// {@endtemplate}
class Multiball extends Component {
  /// {@macro multiball}
  Multiball._({
    required Vector2 position,
    required String onAssetPath,
    required String offAssetPath,
    double rotation = 0,
  }) : super(
          children: [
            MultiballSpriteGroupComponent(
              position: position,
              onAssetPath: onAssetPath,
              offAssetPath: offAssetPath,
            )..angle = rotation,
          ],
        );

  /// {@macro multiball}
  Multiball.a()
      : this._(
          position: Vector2(0, 0),
          onAssetPath: Assets.images.multiball.a.active.keyName,
          offAssetPath: Assets.images.multiball.a.inactive.keyName,
          rotation: 0,
        );

  /// {@macro multiball}
  Multiball.b()
      : this._(
          position: Vector2(0, 0),
          onAssetPath: Assets.images.multiball.b.active.keyName,
          offAssetPath: Assets.images.multiball.b.inactive.keyName,
          rotation: 0,
        );

  /// {@macro multiball}
  Multiball.c()
      : this._(
          position: Vector2(0, 0),
          onAssetPath: Assets.images.multiball.c.active.keyName,
          offAssetPath: Assets.images.multiball.c.inactive.keyName,
          rotation: 0,
        );

  /// {@macro multiball}
  Multiball.d()
      : this._(
          position: Vector2(0, 0),
          onAssetPath: Assets.images.multiball.d.active.keyName,
          offAssetPath: Assets.images.multiball.d.inactive.keyName,
          rotation: 0,
        );

  /// Animates the [Multiball].
  Future<void> animate() async {
    final spriteGroupComponent = firstChild<MultiballSpriteGroupComponent>()
      ?..current = MultiballSpriteState.active;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    spriteGroupComponent?.current = MultiballSpriteState.inactive;
  }
}

/// Indicates the current sprite state of the multiball.
enum MultiballSpriteState {
  /// A lit up multiball.
  active,

  /// A dimmed multiball.
  inactive,
}

/// {@template multiball_sprite_group_component}
/// A [SpriteGroupComponent] for the multiball over the board.
/// {@endtemplate}
@visibleForTesting
class MultiballSpriteGroupComponent
    extends SpriteGroupComponent<MultiballSpriteState> with HasGameRef {
  /// {@macro multiball_sprite_group_component}
  MultiballSpriteGroupComponent({
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
      MultiballSpriteState.active:
          Sprite(gameRef.images.fromCache(_onAssetPath)),
      MultiballSpriteState.inactive:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };
    this.sprites = sprites;

    current = MultiballSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
