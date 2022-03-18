import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template ball}
/// A solid, [BodyType.dynamic] sphere that rolls and bounces along the
/// [PinballGame].
/// {@endtemplate}
class Ball extends BodyComponent<PinballGame> with InitialPosition, Layered {
  /// {@macro ball}
  Ball() {
    // TODO(ruimiguel): while developing Ball can be launched by clicking mouse,
    // and default  layer is Layer.all. But on final game Ball will be always be
    // be launched from Plunger and LauncherRamp will modify it to Layer.board.
    // We need to see what happens if Ball appears from other place like nest
    // bumper, it will need to explicit change layer to Layer.board then.
    layer = Layer.board;
  }

  /// The size of the [Ball]
  final Vector2 size = Vector2.all(2);

  /// Asset location of the sprite that renders with the [Ball].
  ///
  /// Sprite is preloaded by [PinballGameAssetsX].
  static const spritePath = 'components/ball.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(spritePath);
    final tint = gameRef.theme.characterTheme.ballColor.withOpacity(0.5);
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
}
