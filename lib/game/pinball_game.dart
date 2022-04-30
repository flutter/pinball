// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGame extends Forge2DGame
    with
        FlameBloc,
        HasKeyboardHandlerComponents,
        Controls<_GameBallsController>,
        TapDetector {
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
    await add(BoardBackgroundSpriteComponent());
    await add(Drain());
    await add(BottomGroup());
    unawaited(addFromBlueprint(Boundaries()));

    final launcher = Launcher();
    unawaited(addFromBlueprint(launcher));
    await add(Multipliers());
    await add(FlutterForest());
    await addFromBlueprint(SparkyFireZone());
    await addFromBlueprint(AndroidAcres());
    await addFromBlueprint(DinoDesert());
    unawaited(addFromBlueprint(Slingshots()));
    await add(
      GoogleWord(
        position: Vector2(
          BoardDimensions.bounds.center.dx - 4.1,
          BoardDimensions.bounds.center.dy + 1.8,
        ),
      ),
    );

    controller.attachTo(launcher.components.whereType<Plunger>().single);
    await super.onLoad();
  }

  BoardSide? focusedBoardSide;

  @override
  void onTapDown(TapDownInfo info) {
    if (info.raw.kind == PointerDeviceKind.touch) {
      final rocket = children.whereType<RocketSpriteComponent>().first;
      final bounds = rocket.topLeftPosition & rocket.size;

      // NOTE(wolfen): As long as Flame does not have https://github.com/flame-engine/flame/issues/1586 we need to check it at the highest level manually.
      if (bounds.contains(info.eventPosition.game.toOffset())) {
        children.whereType<Plunger>().first.pull();
      } else {
        final leftSide = info.eventPosition.widget.x < canvasSize.x / 2;
        focusedBoardSide = leftSide ? BoardSide.left : BoardSide.right;
        final flippers = descendants().whereType<Flipper>().where((flipper) {
          return flipper.side == focusedBoardSide;
        });
        flippers.first.moveUp();
      }
    }

    super.onTapDown(info);
  }

  @override
  void onTapUp(TapUpInfo info) {
    final rocket = descendants().whereType<RocketSpriteComponent>().first;
    final bounds = rocket.topLeftPosition & rocket.size;

    if (bounds.contains(info.eventPosition.game.toOffset())) {
      children.whereType<Plunger>().first.release();
    } else {
      _moveFlippersDown();
    }
    super.onTapUp(info);
  }

  @override
  void onTapCancel() {
    children.whereType<Plunger>().first.release();

    _moveFlippersDown();
    super.onTapCancel();
  }

  void _moveFlippersDown() {
    if (focusedBoardSide != null) {
      final flippers = descendants().whereType<Flipper>().where((flipper) {
        return flipper.side == focusedBoardSide;
      });
      flippers.first.moveDown();
      focusedBoardSide = null;
    }
  }
}

class _GameBallsController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  _GameBallsController(PinballGame game) : super(game);

  late final Plunger _plunger;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final noBallsLeft = component.descendants().whereType<Ball>().isEmpty;
    final notGameOver = !newState.isGameOver;

    return noBallsLeft && notGameOver;
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
      characterTheme: component.characterTheme,
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

class DebugPinballGame extends PinballGame with FPSCounter {
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
    await add(_DebugInformation());
  }

  // TODO(allisonryan0002): Remove after google letters have been correctly
  // placed.
  // Future<void> _loadBackground() async {
  //   final sprite = await loadSprite(
  //     Assets.images.components.background.path,
  //   );
  //   final spriteComponent = SpriteComponent(
  //     sprite: sprite,
  //     size: Vector2(120, 160),
  //     anchor: Anchor.center,
  //   )
  //     ..position = Vector2(0, -7.8)
  //     ..priority = RenderPriority.boardBackground;

  //   await add(spriteComponent);
  // }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);

    if (info.raw.kind == PointerDeviceKind.mouse) {
      add(ControlledBall.debug()..initialPosition = info.eventPosition.game);
    }
  }
}

class _DebugGameBallsController extends _GameBallsController {
  _DebugGameBallsController(PinballGame game) : super(game);
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
