import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class Ball extends PositionBodyComponent<PinballGame, SpriteComponent>
    with BlocComponent<GameBloc, GameState> {
  Ball({
    required Vector2 position,
    required Vector2 size,
  })  : _position = position,
        _size = size,
        super(size: size);

  final Vector2 _position;
  final Vector2 _size;

  static const spritePath = 'components/ball.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(spritePath);
    positionComponent = SpriteComponent(sprite: sprite, size: _size);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = _size.x / 2;

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
