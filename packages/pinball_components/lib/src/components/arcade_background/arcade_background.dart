import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

export 'cubit/arcade_background_cubit.dart';

/// {@template arcade_background}
/// Background of the arcade that the pinball machine lives in.
/// {@endtemplate}
class ArcadeBackground extends Component with ZIndex {
  /// {@macro arcade_background}
  ArcadeBackground({String? assetPath})
      : this._(
          bloc: ArcadeBackgroundCubit(),
          assetPath: assetPath,
        );

  ArcadeBackground._({required this.bloc, String? assetPath})
      : super(
          children: [
            FlameBlocProvider<ArcadeBackgroundCubit,
                ArcadeBackgroundState>.value(
              value: bloc,
              children: [ArcadeBackgroundSpriteComponent(assetPath: assetPath)],
            )
          ],
        ) {
    zIndex = ZIndexes.arcadeBackground;
  }

  /// Creates an [ArcadeBackground] without any behaviors.
  ///
  /// This can be used for testing [ArcadeBackground]'s behaviors in isolation.
  @visibleForTesting
  ArcadeBackground.test({
    ArcadeBackgroundCubit? bloc,
    String? assetPath,
  })  : bloc = bloc ?? ArcadeBackgroundCubit(),
        super(
          children: [
            FlameBlocProvider<ArcadeBackgroundCubit,
                ArcadeBackgroundState>.value(
              value: bloc ?? ArcadeBackgroundCubit(),
              children: [ArcadeBackgroundSpriteComponent(assetPath: assetPath)],
            )
          ],
        );

  /// Bloc to update the arcade background sprite when a new character is
  /// selected.
  final ArcadeBackgroundCubit bloc;
}

/// {@template arcade_background_sprite_component}
/// [SpriteComponent] for the [ArcadeBackground].
/// {@endtemplate}
@visibleForTesting
class ArcadeBackgroundSpriteComponent extends SpriteComponent
    with
        FlameBlocListenable<ArcadeBackgroundCubit, ArcadeBackgroundState>,
        HasGameRef {
  /// {@macro arcade_background_sprite_component}
  ArcadeBackgroundSpriteComponent({required String? assetPath})
      : _assetPath = assetPath,
        super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0, 72.3),
        );

  final String? _assetPath;

  @override
  void onNewState(ArcadeBackgroundState state) {
    sprite = Sprite(
      gameRef.images.fromCache(state.characterTheme.background.keyName),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images
          .fromCache(_assetPath ?? theme.Assets.images.dash.background.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
