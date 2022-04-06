// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
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
  Future<void> onLoad() async {
    _addContactCallbacks();
    // Fix camera on the center of the board.
    camera
      ..followVector2(Vector2(0, -7.8))
      ..zoom = size.y / 16;

    await _addGameBoundaries();
    unawaited(addFromBlueprint(Boundaries()));
    unawaited(addFromBlueprint(LaunchRamp()));

    final plunger = Plunger(compressionDistance: 29)
      ..initialPosition =
          BoardDimensions.bounds.center.toVector2() + Vector2(41.5, -49);
    await add(plunger);

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

    controller.attachTo(plunger);
    await super.onLoad();
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

  late final Plunger _plunger;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final noBallsLeft = component.descendants().whereType<Ball>().isEmpty;
    final canBallRespawn = newState.balls > 0;

    return noBallsLeft && canBallRespawn;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    _spawnBall();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spawnBall();
  }

  void _spawnBall() {
    final ball = ControlledBall.launch(
      theme: gameRef.theme,
    )..initialPosition = Vector2(
        _plunger.body.position.x,
        _plunger.body.position.y + Ball.size.y,
      );
    component.add(ball);
  }

  /// Attaches the controller to the plunger.
  // TODO(alestiago): Remove this method and use onLoad instead.
  // ignore: use_setters_to_change_properties
  void attachTo(Plunger plunger) {
    _plunger = plunger;
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({
    required PinballTheme theme,
    required PinballAudio audio,
  }) : super(
          theme: theme,
          audio: audio,
        ) {
    controller = _DebugGameBallsController(this);
  }

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

class _DebugGameBallsController extends _GameBallsController {
  _DebugGameBallsController(PinballGame game) : super(game);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final noBallsLeft = component
        .descendants()
        .whereType<ControlledBall>()
        .where(
          (ball) => ball.controller is! DebugBallController,
        )
        .isEmpty;
    final canBallRespawn = newState.balls > 0;

    return noBallsLeft && canBallRespawn;
  }
}
