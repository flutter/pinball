import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:pinball/game/game.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces along the
/// [PinballGame].
/// {@endtemplate}
class Ball extends PositionBodyComponent<PinballGame, SpriteComponent> {
  /// {@macro ball}
  Ball({
    required Vector2 position,
    int? maskBits,
  })  : _position = position,
        _maskBits = maskBits ?? Filter().maskBits,
        super(size: Vector2.all(2));

  /// The initial position of the [Ball] body.
  final Vector2 _position;
  final int _maskBits;

  /// Asset location of the sprite that renders with the [Ball].
  ///
  /// Sprite is preloaded by [PinballGameAssetsX].
  static const spritePath = 'components/ball.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(spritePath);
    final tint = gameRef.theme.characterTheme.ballColor.withOpacity(0.5);
    positionComponent = SpriteComponent(sprite: sprite, size: size)..tint(tint);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;

    final fixtureDef = FixtureDef(shape)..density = 1;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2(_position.x, _position.y + size.y)
      ..type = BodyType.dynamic;

    final body = world.createBody(bodyDef);

    body.createFixture(fixtureDef).filterData.maskBits = _maskBits;
    return body;
  }

  /// Removes the [Ball] from a [PinballGame]; spawning a new [Ball] if
  /// any are left.
  ///
  /// Triggered by [BottomWallBallContactCallback] when the [Ball] falls into
  /// a [BottomWall].
  void lost() {
    shouldRemove = true;

    final bloc = gameRef.read<GameBloc>()..add(const BallLost());

    final shouldBallRespwan = !bloc.state.isLastBall && !bloc.state.isGameOver;
    if (shouldBallRespwan) {
      gameRef.spawnBall();
    }
  }

  /// Modifies maskBits of [Ball] for collisions.
  ///
  /// Changes the [Filter] data for category and maskBits of the [Ball] to
  /// collide with other objects of same bits and ignore others.
  void setMaskBits(int maskBits) {
    body.fixtures.first
      ..filterData.categoryBits = maskBits
      ..filterData.maskBits = maskBits;
  }
}
