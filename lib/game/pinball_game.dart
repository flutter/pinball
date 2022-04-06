// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

class PinballGame extends Forge2DGame
    with
        FlameBloc,
        HasKeyboardHandlerComponents,
        Controls<_GameBallsController> {
  PinballGame({
    required this.theme,
    required this.audio,
  }) {
    images.prefix = '';
    controller = _GameBallsController(this);
  }

  final PinballTheme theme;

  final PinballAudio audio;

  @override
  void onAttach() {
    super.onAttach();
    controller.spawnBall();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _addContactCallbacks();

    await _addGameBoundaries();
    unawaited(addFromBlueprint(Boundaries()));
    unawaited(addFromBlueprint(LaunchRamp()));
    unawaited(_addPlunger());
    unawaited(add(Board()));
    unawaited(addFromBlueprint(DinoWalls()));
    unawaited(_addBonusWord());
    unawaited(addFromBlueprint(SpaceshipRamp()));
    unawaited(
      addFromBlueprint(
        Spaceship(
          position: Vector2(-26.5, 28.5),
        ),
      ),
    );
    unawaited(
      addFromBlueprint(
        SpaceshipRail(),
      ),
    );

    // Fix camera on the center of the board.
    camera
      ..followVector2(Vector2(0, -7.8))
      ..zoom = size.y / 16;
  }

  void _addContactCallbacks() {
    addContactCallback(BallScorePointsCallback(this));
    addContactCallback(BottomWallBallContactCallback());
    addContactCallback(BonusLetterBallContactCallback());
  }

  Future<void> _addGameBoundaries() async {
    await add(BottomWall());
    createBoundaries(this).forEach(add);
  }

  Future<void> _addPlunger() async {
    final plunger = Plunger(compressionDistance: 29)
      ..initialPosition =
          BoardDimensions.bounds.center.toVector2() + Vector2(41.5, -49);
    await add(plunger);
  }

  Future<void> _addBonusWord() async {
    await add(
      BonusWord(
        position: Vector2(
          BoardDimensions.bounds.center.dx - 3.07,
          BoardDimensions.bounds.center.dy - 2.4,
        ),
      ),
    );
  }
}

class _GameBallsController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  _GameBallsController(PinballGame game) : super(game);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    // TODO(alestiago): Fix how the logic works.
    final previousBalls =
        (previousState?.balls ?? 0) + (previousState?.bonusBalls ?? 0);
    final currentBalls = newState.balls + newState.bonusBalls;
    final canBallRespawn = newState.balls > 0 && newState.bonusBalls == 0;

    return previousBalls != currentBalls && canBallRespawn;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    spawnBall();
  }

  Future<void> spawnBall() async {
    // TODO(alestiago): Remove once this logic is moved to controller.
    var plunger = firstChild<Plunger>();
    if (plunger == null) {
      await add(plunger = Plunger(compressionDistance: 1));
    }

    final ball = ControlledBall.launch(
      theme: gameRef.theme,
    )..initialPosition = Vector2(
        plunger.body.position.x,
        plunger.body.position.y + Ball.size.y,
      );
    await add(ball);
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({
    required PinballTheme theme,
    required PinballAudio audio,
  }) : super(
          theme: theme,
          audio: audio,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadBackground();
  }

  // TODO(alestiago): Move to PinballGame once we have the real background
  // component.
  Future<void> _loadBackground() async {
    final sprite = await loadSprite(
      Assets.images.components.background.path,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(120, 160),
      anchor: Anchor.center,
    )
      ..position = Vector2(0, -7.8)
      ..priority = -2;

    await add(spriteComponent);
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      ControlledBall.debug()..initialPosition = info.eventPosition.game,
    );
  }
}
