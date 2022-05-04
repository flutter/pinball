// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGame extends PinballForge2DGame
    with
        FlameBloc,
        HasKeyboardHandlerComponents,
        Controls<_GameBallsController>,
        MultiTouchTapDetector {
  PinballGame({
    required this.characterTheme,
    required this.audio,
  }) : super(gravity: Vector2(0, 30)) {
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
    await add(gameFlowController = GameFlowController(this));
    await add(CameraController(this));

    final machine = [
      BoardBackgroundSpriteComponent(),
      Boundaries(),
      Backboard.waiting(position: Vector2(0, -88)),
    ];
    final decals = [
      GoogleWord(position: Vector2(-4.25, 1.8)),
      Multipliers(),
      Multiballs(),
    ];
    final characterAreas = [
      AndroidAcres(),
      DinoDesert(),
      FlutterForest(),
      SparkyScorch(),
    ];

    await add(
      ZCanvasComponent(
        children: [
          ...machine,
          ...decals,
          ...characterAreas,
          Drain(),
          BottomGroup(),
          Launcher(),
        ],
      ),
    );

    await super.onLoad();
  }

  BoardSide? focusedBoardSide;

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    if (info.raw.kind == PointerDeviceKind.touch) {
      final rocket = descendants().whereType<RocketSpriteComponent>().first;
      final bounds = rocket.topLeftPosition & rocket.size;

      // NOTE(wolfen): As long as Flame does not have https://github.com/flame-engine/flame/issues/1586 we need to check it at the highest level manually.
      if (bounds.contains(info.eventPosition.game.toOffset())) {
        descendants().whereType<Plunger>().single.pullFor(2);
      } else {
        final leftSide = info.eventPosition.widget.x < canvasSize.x / 2;
        focusedBoardSide = leftSide ? BoardSide.left : BoardSide.right;
        final flippers = descendants().whereType<Flipper>().where((flipper) {
          return flipper.side == focusedBoardSide;
        });
        flippers.first.moveUp();
      }
    }

    super.onTapDown(pointerId, info);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    _moveFlippersDown();
    super.onTapUp(pointerId, info);
  }

  @override
  void onTapCancel(int pointerId) {
    _moveFlippersDown();
    super.onTapCancel(pointerId);
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

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final noBallsLeft = component.descendants().whereType<Ball>().isEmpty;
    final notGameOver = !newState.isGameOver;

    return noBallsLeft && notGameOver;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    spawnBall();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    spawnBall();
  }

  void spawnBall() {
    // TODO(alestiago): Refactor with behavioural pattern.
    component.ready().whenComplete(() {
      final plunger = parent!.descendants().whereType<Plunger>().single;
      final ball = ControlledBall.launch(
        characterTheme: component.characterTheme,
      )..initialPosition = Vector2(
          plunger.body.position.x,
          plunger.body.position.y - Ball.size.y,
        );
      component.firstChild<ZCanvasComponent>()?.add(ball);
    });
  }
}

// coverage:ignore-start
class DebugPinballGame extends PinballGame with FPSCounter, PanDetector {
  DebugPinballGame({
    required CharacterTheme characterTheme,
    required PinballAudio audio,
  }) : super(
          characterTheme: characterTheme,
          audio: audio,
        ) {
    controller = _GameBallsController(this);
  }

  Vector2? lineStart;
  Vector2? lineEnd;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_PreviewLine());

    await add(_DebugInformation());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (info.raw.kind == PointerDeviceKind.mouse) {
      final ball = ControlledBall.debug()
        ..initialPosition = info.eventPosition.game;
      firstChild<ZCanvasComponent>()?.add(ball);
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    lineStart = info.eventPosition.game;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    lineEnd = info.eventPosition.game;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (lineEnd != null) {
      final line = lineEnd! - lineStart!;
      onLine(line);
      lineEnd = null;
      lineStart = null;
    }
  }

  void onLine(Vector2 line) {
    final ball = ControlledBall.debug()..initialPosition = lineStart!;
    final impulse = line * -1 * 10;
    ball.add(BallTurboChargingBehavior(impulse: impulse));
    firstChild<ZCanvasComponent>()?.add(ball);
  }
}
// coverage:ignore-end

// coverage:ignore-start
class _PreviewLine extends PositionComponent with HasGameRef<DebugPinballGame> {
  static final _previewLinePaint = Paint()
    ..color = Colors.pink
    ..strokeWidth = 0.4
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (gameRef.lineEnd != null) {
      canvas.drawLine(
        gameRef.lineStart!.toOffset(),
        gameRef.lineEnd!.toOffset(),
        _previewLinePaint,
      );
    }
  }
}
// coverage:ignore-end

// TODO(wolfenrain): investigate this CI failure.
// coverage:ignore-start
class _DebugInformation extends Component with HasGameRef<DebugPinballGame> {
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
