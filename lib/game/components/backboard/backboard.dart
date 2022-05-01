import 'dart:async';

import 'package:flame/components.dart';
import 'package:pinball/game/components/backboard/displays/displays.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard}
/// The [Backboard] of the pinball machine.
/// {@endtemplate}
class Backboard extends PositionComponent with HasGameRef {
  /// {@macro backboard}
  Backboard()
      : super(
          position: Vector2(0, -87),
          anchor: Anchor.bottomCenter,
          priority: RenderPriority.backboardMarquee,
          children: [
            _BackboardSpriteComponent(),
          ],
        );

  /// Puts [InitialsInputDisplay] on the [Backboard].
  Future<void> initialsInput({
    required int score,
    required String characterIconPath,
    InitialsOnSubmit? onSubmit,
  }) async {
    removeAll(children);
    await add(
      InitialsInputDisplay(
        score: score,
        characterIconPath: characterIconPath,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _BackboardSpriteComponent extends SpriteComponent with HasGameRef {
  _BackboardSpriteComponent() : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.backboard.marquee.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
