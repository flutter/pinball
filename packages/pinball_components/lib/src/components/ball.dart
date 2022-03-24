import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces around
/// {@endtemplate}
class Ball<T extends Forge2DGame> extends BodyComponent<T>
    with Layered, InitialPosition {
  /// {@macro ball_body}
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

  /// The size of the [Ball]
  final Vector2 size = Vector2.all(2);

  /// The base [Color] used to tint this [Ball]
  final Color baseColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(Assets.images.ball.keyName);
    final tint = baseColor.withOpacity(0.5);
    await add(
      SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
      )..tint(tint),
    );
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;

    final fixtureDef = FixtureDef(shape)..density = 1;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// Immediatly and completly [stop]s the ball.
  ///
  /// The [Ball] will no longer be affected by any forces, including it's
  /// weight and those emitted from collisions.
  void stop() {
    body.setType(BodyType.static);
  }

  /// Allows the [Ball] to be affected by forces.
  ///
  /// If previously [stop]ed, the previous ball's velocity is not kept.
  void resume() {
    body.setType(BodyType.dynamic);
  }
}
