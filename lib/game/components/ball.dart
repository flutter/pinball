import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/theme/theme.dart';

class Ball extends BodyComponent<PinballGame>
    with BlocComponent<ThemeCubit, ThemeState> {
  Ball({
    required Vector2 position,
  }) : _position = position;

  final Vector2 _position;

  @override
  Body createBody() {
    paint = Paint()
      ..color = gameRef.read<ThemeCubit>().state.theme.characterTheme.ballColor;

    final shape = CircleShape()..radius = 2;

    final fixtureDef = FixtureDef(shape)..density = 1;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void lost() {
    shouldRemove = true;

    final bloc = gameRef.read<GameBloc>()..add(const BallLost());

    final shouldBallRespwan = !bloc.state.isLastBall;
    if (shouldBallRespwan) {
      gameRef.spawnBall();
    }
  }
}
