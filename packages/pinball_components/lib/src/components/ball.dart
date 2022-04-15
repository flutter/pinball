import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces around.
/// {@endtemplate}
class Ball<T extends Forge2DGame> extends BodyComponent<T>
    with Layered, InitialPosition {
  /// {@macro ball}
  Ball({
    required this.baseColor,
  }) {
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

  double _boostTimer = 0;
  static const _boostDuration = 2.0;

  final _BallSpriteComponent _spriteComponent = _BallSpriteComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    await add(
      _spriteComponent..tint(baseColor.withOpacity(0.5)),
    );

    renderBody = false;
  }

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

  @override
  void update(double dt) {
    super.update(dt);
    if (_boostTimer > 0) {
      _boostTimer -= dt;
      final direction = body.linearVelocity.normalized();
      final effect = FireEffect(
        burstPower: _boostTimer,
        direction: direction,
        position: Vector2(body.position.x, body.position.y),
        priority: priority - 1,
      );

      unawaited(gameRef.add(effect));
    }

    _rescaleSize();
    _setPositionalGravity();
  }

  /// Applies a boost on this [Ball].
  void boost(Vector2 impulse) {
    body.linearVelocity = impulse;
    _boostTimer = _boostDuration;
  }

  void _rescaleSize() {
    final boardHeight = BoardDimensions.bounds.height;
    const maxShrinkValue = BoardDimensions.perspectiveShrinkFactor;

    final standardizedYPosition = body.position.y + (boardHeight / 2);

    final scaleFactor = maxShrinkValue +
        ((standardizedYPosition / boardHeight) * (1 - maxShrinkValue));

    body.fixtures.first.shape.radius = (size.x / 2) * scaleFactor;
    _spriteComponent.scale = Vector2.all(scaleFactor);
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

    body.gravityOverride = Vector2(positionalXForce, positionalYForce);
  }
}

class _BallSpriteComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.ball.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}
