// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

class PinballGame extends Forge2DGame
    with
        FlameBloc,
        HasKeyboardHandlerComponents,
        Controls<_GameBallsController> {
  PinballGame({
    required this.characterTheme,
    required this.audio,
  }) {
    images.prefix = '';
    controller = _GameBallsController(this);
  }

  /// Identifier of the play button overlay
  static const playButtonOverlay = 'play_button';

  @override
  Color backgroundColor() => Colors.transparent;

  final CharacterTheme characterTheme;

  final PinballAudio audio;

  late final GameFlowController gameFlowController;

  @override
  Future<void> onLoad() async {
    unawaited(add(gameFlowController = GameFlowController(this)));
    unawaited(add(CameraController(this)));
    unawaited(add(Backboard.waiting(position: Vector2(0, -88))));

    // TODO(allisonryan0002): banish Wall and Board classes in later PR.
    await add(BottomWall());
    unawaited(addFromBlueprint(Boundaries()));
    unawaited(addFromBlueprint(LaunchRamp()));

    final launcher = Launcher();
    unawaited(addFromBlueprint(launcher));
    unawaited(add(Board()));
    await addFromBlueprint(SparkyFireZone());
    await addFromBlueprint(AndroidAcres());
    unawaited(addFromBlueprint(Slingshots()));
    unawaited(addFromBlueprint(DinoWalls()));
    await add(
      GoogleWord(
        position: Vector2(
          BoardDimensions.bounds.center.dx - 4.1,
          BoardDimensions.bounds.center.dy + 1.8,
        ),
      ),
    );

    controller.attachTo(launcher.components.whereType<Plunger>().first);
    await super.onLoad();
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
      characterTheme: gameRef.characterTheme,
    )..initialPosition = Vector2(
        _plunger.body.position.x,
        _plunger.body.position.y - Ball.size.y,
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

class DebugPinballGame extends PinballGame with FPSCounter, TapDetector {
  DebugPinballGame({
    required CharacterTheme characterTheme,
    required PinballAudio audio,
  }) : super(
          characterTheme: characterTheme,
          audio: audio,
        ) {
    controller = _DebugGameBallsController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadBackground();
    await add(_DebugInformation());
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
      ..priority = RenderPriority.background;

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
        .where((ball) => ball.controller is! DebugBallController)
        .isEmpty;
    final canBallRespawn = newState.balls > 0;

    return noBallsLeft && canBallRespawn;
  }
}

// TODO(wolfenrain): investigate this CI failure.
// coverage:ignore-start
class _DebugInformation extends Component with HasGameRef<DebugPinballGame> {
  _DebugInformation() : super(priority: RenderPriority.debugInfo);

  @override
  PositionType get positionType => PositionType.widget;

  final _debugTextPaint = TextPaint(
    style: const TextStyle(
      color: Colors.green,
      fontSize: 10,
    ),
  );

  final _debugBackgroundPaint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    final debugText = [
      'FPS: ${gameRef.fps().toStringAsFixed(1)}',
      'BALLS: ${gameRef.descendants().whereType<ControlledBall>().length}',
    ].join(' | ');

    final height = _debugTextPaint.measureTextHeight(debugText);
    final position = Vector2(0, gameRef.camera.canvasSize.y - height);
    canvas.drawRect(
      position & Vector2(gameRef.camera.canvasSize.x, height),
      _debugBackgroundPaint,
    );
    _debugTextPaint.render(canvas, debugText, position);
  }
}
// coverage:ignore-end
