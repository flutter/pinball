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
          onAssetPath: value.onAssetPath,
          offAssetPath: value.offAssetPath,
          rotation: rotation,
        );

  final MultiplierValue _value;
  final MultiplierSpriteGroupComponent _sprite;

  /// Change current [Sprite] to active or inactive depending on applied
  /// multiplier.
  void toggle(int multiplier) {
    if (_value.equalsTo(multiplier)) {
      _sprite.current = MultiplierSpriteState.active;
    } else {
      _sprite.current = MultiplierSpriteState.inactive;
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
  active,

  /// A dimmed bumper.
  inactive,
}

extension on MultiplierValue {
  String get onAssetPath {
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

  String get offAssetPath {
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
    required String onAssetPath,
    required String offAssetPath,
    required double rotation,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          angle: rotation,
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
