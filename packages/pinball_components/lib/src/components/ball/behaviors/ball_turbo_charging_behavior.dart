import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ball_turbo_charging_behavior}
/// Puts the [Ball] in flames and [_impulse]s it.
/// {@endtemplate}
class BallTurboChargingBehavior extends TimerComponent with ParentIsA<Ball> {
  /// {@macro ball_turbo_charging_behavior}
  BallTurboChargingBehavior({
    required Vector2 impulse,
  })  : _impulse = impulse,
        super(period: 5, removeOnFinish: true);

  final Vector2 _impulse;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    parent.body.linearVelocity = _impulse;
    await parent.add(_TurboChargeSpriteAnimationComponent());
  }

  @override
  void onRemove() {
    parent
        .firstChild<_TurboChargeSpriteAnimationComponent>()!
        .removeFromParent();
    super.onRemove();
  }
}

class _TurboChargeSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef, ZIndex, ParentIsA<Ball> {
  _TurboChargeSpriteAnimationComponent()
      : super(
          anchor: const Anchor(0.53, 0.72),
        ) {
    zIndex = ZIndexes.turboChargeFlame;
  }

  late final Vector2 _textureSize;

  @override
  void update(double dt) {
    super.update(dt);

    final direction = -parent.body.linearVelocity.normalized();
    angle = math.atan2(direction.x, -direction.y);
    size = (_textureSize / 45) * parent.body.fixtures.first.shape.radius;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.ball.flameEffect.keyName,
    );

    const amountPerRow = 8;
    const amountPerColumn = 4;
    _textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn,
        amountPerRow: amountPerRow,
        stepTime: 1 / 24,
        textureSize: _textureSize,
      ),
    );
  }
}
