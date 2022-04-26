import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';

/// {@template multiplier}
/// A [Component] for the multiplier over the board.
/// {@endtemplate}
class Multiplier extends Component {
  /// {@macro multiplier}
  Multiplier({
    required int value,
    required Vector2 position,
    double rotation = 0,
  })  : assert(
          2 <= value && value <= 6,
          'multiplier value must be in range 2 <= value <= 6',
        ),
        _value = value,
        _position = position,
        _rotation = rotation,
        super();

  final int _value;
  final Vector2 _position;
  final double _rotation;
  late final MultiplierSpriteGroupComponent _sprite;

  /// Change current [Sprite] to active or inactive depending on applied
  /// multiplier.
  void toggle(int multiplier) {
    if (multiplier == _value) {
      _sprite.current = MultiplierSpriteState.active;
    } else {
      _sprite.current = MultiplierSpriteState.inactive;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String? onAssetPath;
    String? offAssetPath;

    switch (_value) {
      case 2:
        onAssetPath = Assets.images.multiplier.x2.active.keyName;
        offAssetPath = Assets.images.multiplier.x2.inactive.keyName;
        break;
      case 3:
        onAssetPath = Assets.images.multiplier.x3.active.keyName;
        offAssetPath = Assets.images.multiplier.x3.inactive.keyName;
        break;
      case 4:
        onAssetPath = Assets.images.multiplier.x4.active.keyName;
        offAssetPath = Assets.images.multiplier.x4.inactive.keyName;
        break;
      case 5:
        onAssetPath = Assets.images.multiplier.x5.active.keyName;
        offAssetPath = Assets.images.multiplier.x5.inactive.keyName;
        break;
      case 6:
        onAssetPath = Assets.images.multiplier.x6.active.keyName;
        offAssetPath = Assets.images.multiplier.x6.inactive.keyName;
        break;
    }

    _sprite = MultiplierSpriteGroupComponent(
      position: _position,
      onAssetPath: onAssetPath!,
      offAssetPath: offAssetPath!,
    )..angle = _rotation;

    await add(_sprite);
  }
}

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
@visibleForTesting
class MultiplierSpriteGroupComponent
    extends SpriteGroupComponent<MultiplierSpriteState> with HasGameRef {
  /// {@macro multiplier_sprite_group_component}
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
