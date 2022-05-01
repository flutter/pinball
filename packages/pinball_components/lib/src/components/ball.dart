import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces around.
/// {@endtemplate}
class Ball<T extends Forge2DGame> extends BodyComponent<T>
    with Layered, InitialPosition, ZIndex {
  /// {@macro ball}
  Ball({
    required this.baseColor,
  }) : super(
          renderBody: false,
          children: [
            _BallSpriteComponent()..tint(baseColor.withOpacity(0.5)),
          ],
        ) {
    // TODO(ruimiguel): while developing Ball can be launched by clicking mouse,
    // and default  layer is Layer.all. But on final game Ball will be always be
    // be launched from Plunger and LauncherRamp will modify it to Layer.board.
    // We need to see what happens if Ball appears from other place like nest
    // bumper, it will need to explicit change layer to Layer.board then.
    layer = Layer.board;
  }

  /// The size of the [Ball].
  static final Vector2 size = Vector2.all(4.13);

  /// The base [Color] used to tint this [Ball].
  final Color baseColor;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;
    final fixtureDef = FixtureDef(
      shape,
      density: 1,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
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
    body.gravityScale = Vector2(0, 1);
  }

  /// Applies a boost and [_TurboChargeSpriteAnimationComponent] on this [Ball].
  Future<void> boost(Vector2 impulse) async {
    body.linearVelocity = impulse;
    await add(_TurboChargeSpriteAnimationComponent());
  }

  @override
  void update(double dt) {
    super.update(dt);

    _rescaleSize();
    _setPositionalGravity();
  }

  void _rescaleSize() {
    final boardHeight = BoardDimensions.bounds.height;
    const maxShrinkValue = BoardDimensions.perspectiveShrinkFactor;

    final standardizedYPosition = body.position.y + (boardHeight / 2);

    final scaleFactor = maxShrinkValue +
        ((standardizedYPosition / boardHeight) * (1 - maxShrinkValue));

    body.fixtures.first.shape.radius = (size.x / 2) * scaleFactor;

    // TODO(alestiago): Revisit and see if there's a better way to do this.
    final spriteComponent = firstChild<_BallSpriteComponent>();
    spriteComponent?.scale = Vector2.all(scaleFactor);
  }

  void _setPositionalGravity() {
    final defaultGravity = gameRef.world.gravity.y;
    final maxXDeviationFromCenter = BoardDimensions.bounds.width / 2;
    const maxXGravityPercentage =
        (1 - BoardDimensions.perspectiveShrinkFactor) / 2;
    final xDeviationFromCenter = body.position.x;

    final positionalXForce = ((xDeviationFromCenter / maxXDeviationFromCenter) *
            maxXGravityPercentage) *
        defaultGravity;

    final positionalYForce = math.sqrt(
      math.pow(defaultGravity, 2) - math.pow(positionalXForce, 2),
    );

    body.gravityOverride = Vector2(-positionalXForce, positionalYForce);
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

class _TurboChargeSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef, ZIndex {
  _TurboChargeSpriteAnimationComponent()
      : super(
          anchor: const Anchor(0.53, 0.72),
          removeOnFinish: true,
        ) {
    zIndex = ZIndexes.turboChargeFlame;
  }

  late final Vector2 _textureSize;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = await gameRef.images.load(
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
        loop: false,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (parent != null) {
      final body = (parent! as BodyComponent).body;
      final direction = -body.linearVelocity.normalized();
      angle = math.atan2(direction.x, -direction.y);
      size = (_textureSize / 45) * body.fixtures.first.shape.radius;
    }
  }
}
