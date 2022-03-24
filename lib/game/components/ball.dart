import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';

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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(Assets.images.components.ball.path);
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
