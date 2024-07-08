import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

export 'behaviors/behaviors.dart';
export 'cubit/ball_cubit.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces around.
/// {@endtemplate}
class Ball extends BodyComponent with Layered, InitialPosition, ZIndex {
  /// {@macro ball}
  Ball({String? assetPath}) : this._(bloc: BallCubit(), assetPath: assetPath);

  Ball._({required this.bloc, String? assetPath})
      : super(
          renderBody: false,
          children: [
            FlameBlocProvider<BallCubit, BallState>.value(
              value: bloc,
              children: [BallSpriteComponent(assetPath: assetPath)],
            ),
            BallScalingBehavior(),
            BallGravitatingBehavior(),
          ],
        ) {
    layer = Layer.board;
  }

  /// Creates a [Ball] without any behaviors.
  ///
  /// This can be used for testing [Ball]'s behaviors in isolation.
  @visibleForTesting
  Ball.test({
    BallCubit? bloc,
    String? assetPath,
  })  : bloc = bloc ?? BallCubit(),
        super(
          children: [
            FlameBlocProvider<BallCubit, BallState>.value(
              value: bloc ?? BallCubit(),
              children: [BallSpriteComponent(assetPath: assetPath)],
            ),
          ],
        );

  /// Bloc to update the ball sprite when a new character is selected.
  final BallCubit bloc;

  /// The size of the [Ball].
  static final Vector2 size = Vector2.all(4.13);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
      bullet: true,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }

  /// Immediately and completely [stop]s the ball.
  ///
  /// The [Ball] will no longer be affected by any forces, including it's
  /// weight and those emitted from collisions.
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

/// {@template ball_sprite_component}
/// Visual representation of the [Ball].
/// {@endtemplate}
@visibleForTesting
class BallSpriteComponent extends SpriteComponent
    with HasGameRef, FlameBlocListenable<BallCubit, BallState> {
  /// {@macro ball_sprite_component}
  BallSpriteComponent({required String? assetPath})
      : _assetPath = assetPath,
        super(anchor: Anchor.center);

  final String? _assetPath;

  @override
  void onNewState(BallState state) {
    sprite = Sprite(
      gameRef.images.fromCache(state.characterTheme.ball.keyName),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images
          .fromCache(_assetPath ?? theme.Assets.images.dash.ball.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 12.5;
  }
}
