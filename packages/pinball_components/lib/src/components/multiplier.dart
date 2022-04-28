// ignore_for_file: public_member_api_docs

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';

/// {@template multiplier}
/// A [Component] for the multiplier over the board.
/// {@endtemplate}
class Multiplier extends Component {
  /// {@macro multiplier}
  Multiplier({
    required MultiplierValue value,
    required Vector2 position,
    double rotation = 0,
  })  : _value = value,
        _sprite = MultiplierSpriteGroupComponent(
          position: position,
          litAssetPath: value.litAssetPath,
          dimmedAssetPath: value.dimmedAssetPath,
          rotation: rotation,
        );

  final MultiplierValue _value;
  final MultiplierSpriteGroupComponent _sprite;

  /// Change current [Sprite] to active or inactive depending on applied
  /// multiplier.
  void toggle(int multiplier) {
    if (_value.equalsTo(multiplier)) {
      _sprite.current = MultiplierSpriteState.lit;
    } else {
      _sprite.current = MultiplierSpriteState.dimmed;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_sprite);
  }
}

/// Available multiplier values.
enum MultiplierValue {
  x2,
  x3,
  x4,
  x5,
  x6,
}

/// Indicates the current sprite state of the multiplier.
enum MultiplierSpriteState {
  /// A lit up bumper.
  lit,

  /// A dimmed bumper.
  dimmed,
}

extension on MultiplierValue {
  String get litAssetPath {
    switch (this) {
      case MultiplierValue.x2:
        return Assets.images.multiplier.x2.lit.keyName;
      case MultiplierValue.x3:
        return Assets.images.multiplier.x3.lit.keyName;
      case MultiplierValue.x4:
        return Assets.images.multiplier.x4.lit.keyName;
      case MultiplierValue.x5:
        return Assets.images.multiplier.x5.lit.keyName;
      case MultiplierValue.x6:
        return Assets.images.multiplier.x6.lit.keyName;
    }
  }

  String get dimmedAssetPath {
    switch (this) {
      case MultiplierValue.x2:
        return Assets.images.multiplier.x2.dimmed.keyName;
      case MultiplierValue.x3:
        return Assets.images.multiplier.x3.dimmed.keyName;
      case MultiplierValue.x4:
        return Assets.images.multiplier.x4.dimmed.keyName;
      case MultiplierValue.x5:
        return Assets.images.multiplier.x5.dimmed.keyName;
      case MultiplierValue.x6:
        return Assets.images.multiplier.x6.dimmed.keyName;
    }
  }

  bool equalsTo(int value) {
    switch (this) {
      case MultiplierValue.x2:
        return value == 2;
      case MultiplierValue.x3:
        return value == 3;
      case MultiplierValue.x4:
        return value == 4;
      case MultiplierValue.x5:
        return value == 5;
      case MultiplierValue.x6:
        return value == 6;
    }
  }
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
    required String litAssetPath,
    required String dimmedAssetPath,
    required double rotation,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          angle: rotation,
        );

  final String _litAssetPath;
  final String _dimmedAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = {
      MultiplierSpriteState.lit:
          Sprite(gameRef.images.fromCache(_litAssetPath)),
      MultiplierSpriteState.dimmed:
          Sprite(gameRef.images.fromCache(_dimmedAssetPath)),
    };
    this.sprites = sprites;

    current = MultiplierSpriteState.dimmed;
    size = sprites[current]!.originalSize / 10;
  }
}
