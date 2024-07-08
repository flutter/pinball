import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';
import 'package:pinball_components/src/pinball_components.dart';

export 'cubit/multiball_cubit.dart';

/// {@template multiball}
/// A [Component] for the multiball lighting decals on the board.
/// {@endtemplate}
class Multiball extends Component {
  /// {@macro multiball}
  Multiball._({
    required Vector2 position,
    double rotation = 0,
    Iterable<Component>? children,
    required this.bloc,
  }) : super(
          children: [
            MultiballBlinkingBehavior(),
            MultiballSpriteGroupComponent(
              position: position,
              litAssetPath: Assets.images.multiball.lit.keyName,
              dimmedAssetPath: Assets.images.multiball.dimmed.keyName,
              rotation: rotation,
              state: bloc.state.lightState,
            ),
            ...?children,
          ],
        );

  /// {@macro multiball}
  Multiball.a({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-23.3, 7.5),
          rotation: -27 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.b({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-7.65, -6.2),
          rotation: -2 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.c({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(-1.1, -9.3),
          rotation: 6 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// {@macro multiball}
  Multiball.d({
    Iterable<Component>? children,
  }) : this._(
          position: Vector2(14.8, 7),
          rotation: 27 * math.pi / 180,
          bloc: MultiballCubit(),
          children: children,
        );

  /// Creates an [Multiball] without any children.
  ///
  /// This can be used for testing [Multiball]'s behaviors in isolation.
  @visibleForTesting
  Multiball.test({
    required this.bloc,
  });

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
class MultiballSpriteGroupComponent
    extends SpriteGroupComponent<MultiballLightState>
    with HasGameRef, ParentIsA<Multiball> {
  /// {@macro multiball_sprite_group_component}
  MultiballSpriteGroupComponent({
    required Vector2 position,
    required String litAssetPath,
    required String dimmedAssetPath,
    required double rotation,
    required MultiballLightState state,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
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
    parent.bloc.stream.listen((state) => current = state.lightState);

    final sprites = {
      MultiballLightState.lit: Sprite(
        gameRef.images.fromCache(_litAssetPath),
      ),
      MultiballLightState.dimmed:
          Sprite(gameRef.images.fromCache(_dimmedAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
