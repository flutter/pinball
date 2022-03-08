import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/theme/theme.dart';

class Ball extends PositionBodyComponent<PinballGame, SpriteComponent> {
  Ball({
    required Vector2 position,
  })  : _position = position,
        super(size: ballSize);

  static final ballSize = Vector2.all(2);

  final Vector2 _position;

  static const spritePath = 'components/ball.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(spritePath);
    positionComponent = SpriteComponent(sprite: sprite, size: ballSize);
  }

  @override
  Body createBody() {
    paint = Paint()
      ..color = gameRef.read<ThemeCubit>().state.theme.characterTheme.ballColor;

    final shape = CircleShape()..radius = ballSize.x / 2;

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
