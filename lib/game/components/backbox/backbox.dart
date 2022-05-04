import 'dart:async';

import 'package:flame/components.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template backbox}
/// The [Backbox] of the pinball machine.
/// {@endtemplate}
class Backbox extends PositionComponent with HasGameRef, ZIndex {
  /// {@macro backbox}
  Backbox()
      : super(
          position: Vector2(0, -87),
          anchor: Anchor.bottomCenter,
          children: [
            _BackboxSpriteComponent(),
          ],
        ) {
    zIndex = ZIndexes.backbox;
  }

  /// Puts [InitialsInputDisplay] on the [Backbox].
  Future<void> initialsInput({
    required int score,
    required String characterIconPath,
    InitialsOnSubmit? onSubmit,
  }) async {
    removeAll(children.where((child) => child is! _BackboxSpriteComponent));
    await add(
      InitialsInputDisplay(
        score: score,
        characterIconPath: characterIconPath,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _BackboxSpriteComponent extends SpriteComponent with HasGameRef {
  _BackboxSpriteComponent() : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.backbox.marquee.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}
