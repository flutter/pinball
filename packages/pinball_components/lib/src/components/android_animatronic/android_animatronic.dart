import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_animatronic/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template android_animatronic}
/// Animated Android that sits on top of the [AndroidSpaceship].
/// {@endtemplate}
class AndroidAnimatronic extends BodyComponent
    with InitialPosition, Layered, ZIndex {
  /// {@macro android_animatronic}
  AndroidAnimatronic({Iterable<Component>? children})
      : super(
          children: [
            _AndroidAnimatronicSpriteAnimationComponent(),
            AndroidAnimatronicBallContactBehavior(),
            ...?children,
          ],
          renderBody: false,
        ) {
    layer = Layer.spaceship;
    zIndex = ZIndexes.androidHead;
  }

  /// Creates an [AndroidAnimatronic] without any children.
  ///
  /// This can be used for testing [AndroidAnimatronic]'s behaviors in
  /// isolation.
  @visibleForTesting
  AndroidAnimatronic.test();

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 3.1,
      minorRadius: 2,
    )..rotate(1.4);
    final bodyDef = BodyDef(position: initialPosition);

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

class _AndroidAnimatronicSpriteAnimationComponent
    extends SpriteAnimationComponent with HasGameRef {
  _AndroidAnimatronicSpriteAnimationComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-0.24, -2.6),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.android.spaceship.animatronic.keyName,
    );

    const amountPerRow = 18;
    const amountPerColumn = 4;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn,
        amountPerRow: amountPerRow,
        stepTime: 1 / 24,
        textureSize: textureSize,
      ),
    );
  }
}
