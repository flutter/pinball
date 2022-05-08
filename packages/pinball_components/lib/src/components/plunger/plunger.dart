import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/plunger/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// play field.
///
/// [Plunger] ignores gravity so the player controls its downward [pull].
/// {@endtemplate}
class Plunger extends BodyComponent with InitialPosition, Layered, ZIndex {
  /// {@macro plunger}
  Plunger()
      : super(
          renderBody: false,
          children: [
            _PlungerSpriteAnimationGroupComponent(),
            PlungerJointingBehavior(compressionDistance: 9.2),
            PlungerKeyControllingBehavior(),
          ],
        ) {
    zIndex = ZIndexes.plunger;
    layer = Layer.launcher;
  }

  /// Creates a [Plunger] without any children.
  ///
  /// This can be used for testing [Plunger]'s behaviors in isolation.
  @visibleForTesting
  Plunger.test();

  List<FixtureDef> _createFixtureDefs() {
    final leftShapeVertices = [
      Vector2(0, 0),
      Vector2(-1.8, 0),
      Vector2(-1.8, -2.2),
      Vector2(0, -0.3),
    ]..forEach((vector) => vector.rotate(BoardDimensions.perspectiveAngle));
    final leftTriangleShape = PolygonShape()..set(leftShapeVertices);

    final rightShapeVertices = [
      Vector2(0, 0),
      Vector2(1.8, 0),
      Vector2(1.8, -2.2),
      Vector2(0, -0.3),
    ]..forEach((vector) => vector.rotate(BoardDimensions.perspectiveAngle));
    final rightTriangleShape = PolygonShape()..set(rightShapeVertices);

    return [
      FixtureDef(
        leftTriangleShape,
        density: 80,
      ),
      FixtureDef(
        rightTriangleShape,
        density: 80,
      ),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      gravityScale: Vector2.zero(),
    );
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  var _pullingDownTime = 0.0;

  /// Pulls the plunger down for the given amount of [seconds].
  // ignore: use_setters_to_change_properties
  void pullFor(double seconds) {
    _pullingDownTime = seconds;
  }

  /// Set a constant downward velocity on the [Plunger].
  void pull() {
    final sprite = firstChild<_PlungerSpriteAnimationGroupComponent>()!;

    body.linearVelocity = Vector2(0, 7);
    sprite.pull();
  }

  /// Set an upward velocity on the [Plunger].
  ///
  /// The velocity's magnitude depends on how far the [Plunger] has been pulled
  /// from its original [initialPosition].
  void release() {
    add(PlungerNoiseBehavior());
    final sprite = firstChild<_PlungerSpriteAnimationGroupComponent>()!;

    _pullingDownTime = 0;
    final velocity = (initialPosition.y - body.position.y) * 11;
    body.linearVelocity = Vector2(0, velocity);
    sprite.release();
  }

  @override
  void update(double dt) {
    // Ensure that we only pull or release when the time is greater than zero.
    if (_pullingDownTime > 0) {
      _pullingDownTime -= PinballForge2DGame.clampDt(dt);
      if (_pullingDownTime <= 0) {
        release();
      } else {
        pull();
      }
    }
    super.update(dt);
  }
}

/// Animation states associated with a [Plunger].
enum _PlungerAnimationState {
  /// Pull state.
  pull,

  /// Release state.
  release,
}

/// Animations for pulling and releasing [Plunger].
class _PlungerSpriteAnimationGroupComponent
    extends SpriteAnimationGroupComponent<_PlungerAnimationState>
    with HasGameRef {
  _PlungerSpriteAnimationGroupComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(1.87, 14.9),
        );

  void pull() {
    if (current != _PlungerAnimationState.pull) {
      animation?.reset();
    }
    current = _PlungerAnimationState.pull;
  }

  void release() {
    if (current != _PlungerAnimationState.release) {
      animation?.reset();
    }
    current = _PlungerAnimationState.release;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await gameRef.images.load(
      Assets.images.plunger.plunger.keyName,
    );
    const amountPerRow = 20;
    const amountPerColumn = 1;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;
    final pullAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn ~/ 2,
        amountPerRow: amountPerRow ~/ 2,
        stepTime: 1 / 24,
        textureSize: textureSize,
        texturePosition: Vector2.zero(),
        loop: false,
      ),
    );
    animations = {
      _PlungerAnimationState.release: pullAnimation.reversed(),
      _PlungerAnimationState.pull: pullAnimation,
    };
    current = _PlungerAnimationState.release;
  }
}