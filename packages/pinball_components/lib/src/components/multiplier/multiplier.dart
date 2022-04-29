// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/src/components/multiplier/cubit/multiplier_cubit.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/multiplier_cubit.dart';

/// {@template multiplier}
/// A [Component] for the multiplier over the board.
/// {@endtemplate}
class Multiplier extends Component {
  /// {@macro multiplier}
  Multiplier._({
    required MultiplierValue value,
    required Vector2 position,
    required double rotation,
    required this.bloc,
  })  : _value = value,
        _position = position,
        _rotation = rotation,
        super();

  /// {@macro multiplier}
  Multiplier.x2({
    required Vector2 position,
    required double rotation,
  }) : this._(
          value: MultiplierValue.x2,
          position: position,
          rotation: rotation,
          bloc: MultiplierCubit(MultiplierValue.x2),
        );

  /// {@macro multiplier}
  Multiplier.x3({
    required Vector2 position,
    required double rotation,
  }) : this._(
          value: MultiplierValue.x3,
          position: position,
          rotation: rotation,
          bloc: MultiplierCubit(MultiplierValue.x3),
        );

  /// {@macro multiplier}
  Multiplier.x4({
    required Vector2 position,
    required double rotation,
  }) : this._(
          value: MultiplierValue.x4,
          position: position,
          rotation: rotation,
          bloc: MultiplierCubit(MultiplierValue.x4),
        );

  /// {@macro multiplier}
  Multiplier.x5({
    required Vector2 position,
    required double rotation,
  }) : this._(
          value: MultiplierValue.x5,
          position: position,
          rotation: rotation,
          bloc: MultiplierCubit(MultiplierValue.x5),
        );

  /// {@macro multiplier}
  Multiplier.x6({
    required Vector2 position,
    required double rotation,
  }) : this._(
          value: MultiplierValue.x6,
          position: position,
          rotation: rotation,
          bloc: MultiplierCubit(MultiplierValue.x6),
        );

  /// Creates a [Multiplier] without any children.
  ///
  /// This can be used for testing [Multiplier]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  Multiplier.test({
    required MultiplierValue value,
    required this.bloc,
  })  : _value = value,
        _position = Vector2.zero(),
        _rotation = 0;

// TODO(ruimiguel): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  final MultiplierCubit bloc;

  final MultiplierValue _value;
  final Vector2 _position;
  final double _rotation;
  late final MultiplierSpriteGroupComponent _sprite;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _sprite = MultiplierSpriteGroupComponent(
      position: _position,
      litAssetPath: _value.litAssetPath,
      dimmedAssetPath: _value.dimmedAssetPath,
      rotation: _rotation,
      current: bloc.state,
    );
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
}

/// {@template multiplier_sprite_group_component}
/// A [SpriteGroupComponent] for the multiplier over the board.
/// {@endtemplate}
@visibleForTesting
class MultiplierSpriteGroupComponent
    extends SpriteGroupComponent<MultiplierSpriteState>
    with HasGameRef, ParentIsA<Multiplier> {
  /// {@macro multiplier_sprite_group_component}
  MultiplierSpriteGroupComponent({
    required Vector2 position,
    required String litAssetPath,
    required String dimmedAssetPath,
    required double rotation,
    required MultiplierState current,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          angle: rotation,
          current: current.spriteState,
        );

  final String _litAssetPath;
  final String _dimmedAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state.spriteState);

    final sprites = {
      MultiplierSpriteState.lit:
          Sprite(gameRef.images.fromCache(_litAssetPath)),
      MultiplierSpriteState.dimmed:
          Sprite(gameRef.images.fromCache(_dimmedAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
