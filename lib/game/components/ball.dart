import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:pinball/game/game.dart';

class Ball extends BodyComponent<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  Ball({
    required Vector2 position,
  }) : _position = position {
    // TODO(alestiago): Use asset instead of color when provided.
    paint = Paint()..color = const Color(0xFFFFFFFF);
  }

  final Vector2 _position;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2;

    final fixtureDef = FixtureDef(shape)..density = 1;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onRemove() {
    final bloc = gameRef.read<GameBloc>();

    final shouldBallrespwan = bloc.state.balls > 1;

    bloc.add(const BallLost());

    if (shouldBallrespwan) {
      gameRef.resetBall();
    }

    super.onRemove();
  }
}
