import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';
import 'package:pinball_components/src/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/multiball_cubit.dart';

/// {@template multiball}
/// A [Component] for the multiball lighting decals on the board.
/// {@endtemplate}
class Multiball extends Component {
  /// {@macro multiball}
  Multiball._({
    required Vector2 position,
    required String onAssetPath,
    required String offAssetPath,
    double rotation = 0,
    Iterable<Component>? children,
    required this.bloc,
  }) : super(
          children: [
            MultiballBlinkingBehavior(),
            MultiballSpriteGroupComponent(
              position: position,
              onAssetPath: onAssetPath,
              offAssetPath: offAssetPath,
              rotation: rotation,
              state: bloc.state,
            ),
            ...?children,
          ],
        );

  /// {@macro multiball}
  Multiball.a({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-23, 7.5),
          onAssetPath: Assets.images.multiball.a.lit.keyName,
          offAssetPath: Assets.images.multiball.a.dimmed.keyName,
          rotation: -24 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.b({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-7, -6.5),
          onAssetPath: Assets.images.multiball.b.lit.keyName,
          offAssetPath: Assets.images.multiball.b.dimmed.keyName,
          rotation: -5 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.c({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-0.5, -9.5),
          onAssetPath: Assets.images.multiball.c.lit.keyName,
          offAssetPath: Assets.images.multiball.c.dimmed.keyName,
          rotation: 3 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.d({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(15, 7),
          onAssetPath: Assets.images.multiball.d.lit.keyName,
          offAssetPath: Assets.images.multiball.d.dimmed.keyName,
          rotation: 24 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// Creates an [Multiball] without any children.
  ///
  /// This can be used for testing [Multiball]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  Multiball.test({
    required this.bloc,
  });

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final MultiballCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }
}

/// {@template multiball_sprite_group_component}
/// A [SpriteGroupComponent] for the multiball over the board.
/// {@endtemplate}
@visibleForTesting
class MultiballSpriteGroupComponent extends SpriteGroupComponent<MultiballState>
    with HasGameRef, ParentIsA<Multiball> {
  /// {@macro multiball_sprite_group_component}
  MultiballSpriteGroupComponent({
    required Vector2 position,
    required String onAssetPath,
    required String offAssetPath,
    required double rotation,
    required MultiballState state,
  })  : _litAssetPath = onAssetPath,
        _dimmedAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          angle: rotation,
          current: state,
        );

  final String _litAssetPath;
  final String _dimmedAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      MultiballState.lit: Sprite(gameRef.images.fromCache(_litAssetPath)),
      MultiballState.dimmed: Sprite(gameRef.images.fromCache(_dimmedAssetPath)),
    };
    this.sprites = sprites;

    current = MultiballState.dimmed;
    size = sprites[current]!.originalSize / 10;
  }
}
