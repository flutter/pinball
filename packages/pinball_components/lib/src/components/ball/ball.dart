import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'behaviors/behaviors.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces around.
/// {@endtemplate}
class Ball extends BodyComponent with Layered, InitialPosition, ZIndex {
  /// {@macro ball}
  Ball({
    required this.baseColor,
  }) : super(
          renderBody: false,
          children: [
            _BallSpriteComponent()..tint(baseColor.withOpacity(0.5)),
            BallScalingBehavior(),
            BallGravitatingBehavior(),
          ],
        ) {
    // TODO(ruimiguel): while developing Ball can be launched by clicking mouse,
    // and default  layer is Layer.all. But on final game Ball will be always be
    // be launched from Plunger and LauncherRamp will modify it to Layer.board.
    // We need to see what happens if Ball appears from other place like nest
    // bumper, it will need to explicit change layer to Layer.board then.
    layer = Layer.board;
  }

  /// Creates a [Ball] without any behaviors.
  ///
  /// This can be used for testing [Ball]'s behaviors in isolation.
  @visibleForTesting
  Ball.test({required this.baseColor})
      : super(
          children: [_BallSpriteComponent()],
        );

  /// The size of the [Ball].
  static final Vector2 size = Vector2.all(4.13);

  /// The base [Color] used to tint this [Ball].
  final Color baseColor;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape, 1);
  }

  /// Immediatly and completly [stop]s the ball.
  ///
  /// The [Ball] will no longer be affected by any forces, including it's
  /// weight and those emitted from collisions.
  // TODO(allisonryan0002): prevent motion from contact with other balls.
  void stop() {
    body
      ..gravityScale = Vector2.zero()
      ..linearVelocity = Vector2.zero()
      ..angularVelocity = 0;
  }

  /// Allows the [Ball] to be affected by forces.
  ///
  /// If previously [stop]ped, the previous ball's velocity is not kept.
  void resume() {
    body.gravityScale = Vector2(1, 1);
  }
}

class _BallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.ball.ball.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}
