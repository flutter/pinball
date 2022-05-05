// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
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
    required this.leaderboardRepository,
    required this.l10n,
    required this.player,
  }) : super(gravity: Vector2(0, 30)) {
    images.prefix = '';
    controller = _GameBallsController(this);
  }

  /// Identifier of the play button overlay
  static const playButtonOverlay = 'play_button';

  @override
  Color backgroundColor() => Colors.transparent;

  final CharacterTheme characterTheme;

  final PinballPlayer player;

  final LeaderboardRepository leaderboardRepository;

  final AppLocalizations l10n;

  @override
  Future<void> onLoad() async {
    await add(CameraController(this));

    final machine = [
      BoardBackgroundSpriteComponent(),
      Boundaries(),
      Backbox(leaderboardRepository: leaderboardRepository),
    ];
    final decals = [
      GoogleWord(position: Vector2(-4.25, 1.8)),
      Multipliers(),
      Multiballs(),
      SkillShot(
        children: [
          ScoringContactBehavior(points: Points.oneMillion),
        ],
      ),
    ];
    final characterAreas = [
      AndroidAcres(),
      DinoDesert(),
      FlutterForest(),
      SparkyScorch(),
    ];

    await addAll(
      [
        GameBlocStatusListener(),
        CanvasComponent(
          onSpritePainted: (paint) {
            if (paint.filterQuality != FilterQuality.medium) {
              paint.filterQuality = FilterQuality.medium;
            }
          },
          children: [
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
          ],
        ),
      ],
    );

    await super.onLoad();
  }

  final focusedBoardSide = <int, BoardSide>{};

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
        focusedBoardSide[pointerId] =
            leftSide ? BoardSide.left : BoardSide.right;
        final flippers = descendants().whereType<Flipper>().where((flipper) {
          return flipper.side == focusedBoardSide[pointerId];
        });
        flippers.first.moveUp();
      }
    }

    super.onTapDown(pointerId, info);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    _moveFlippersDown(pointerId);
    super.onTapUp(pointerId, info);
  }

  @override
  void onTapCancel(int pointerId) {
    _moveFlippersDown(pointerId);
    super.onTapCancel(pointerId);
  }

  void _moveFlippersDown(int pointerId) {
    if (focusedBoardSide[pointerId] != null) {
      final flippers = descendants().whereType<Flipper>().where((flipper) {
        return flipper.side == focusedBoardSide[pointerId];
      });
      flippers.first.moveDown();
      focusedBoardSide.remove(pointerId);
    }
  }
}

class _GameBallsController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  _GameBallsController(PinballGame game) : super(game);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final noBallsLeft = component.descendants().whereType<Ball>().isEmpty;
    return noBallsLeft && newState.status.isPlaying;
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
      component.descendants().whereType<ZCanvasComponent>().single.add(ball);
    });
  }
}

class DebugPinballGame extends PinballGame with FPSCounter, PanDetector {
  DebugPinballGame({
    required CharacterTheme characterTheme,
    required LeaderboardRepository leaderboardRepository,
    required AppLocalizations l10n,
    required PinballPlayer player,
  }) : super(
          characterTheme: characterTheme,
          player: player,
          leaderboardRepository: leaderboardRepository,
          l10n: l10n,
        ) {
    controller = _GameBallsController(this);
  }

  Vector2? lineStart;
  Vector2? lineEnd;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(PreviewLine());

    await add(_DebugInformation());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (info.raw.kind == PointerDeviceKind.mouse) {
      final canvas = descendants().whereType<ZCanvasComponent>().single;
      final ball = ControlledBall.debug()
        ..initialPosition = info.eventPosition.game;
      canvas.add(ball);
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
      _turboChargeBall(line);
      lineEnd = null;
      lineStart = null;
    }
  }

  void _turboChargeBall(Vector2 line) {
    final canvas = descendants().whereType<ZCanvasComponent>().single;
    final ball = ControlledBall.debug()..initialPosition = lineStart!;
    final impulse = line * -1 * 10;
    ball.add(BallTurboChargingBehavior(impulse: impulse));
    canvas.add(ball);
  }
}

// coverage:ignore-start
class PreviewLine extends PositionComponent with HasGameRef<DebugPinballGame> {
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

// TODO(wolfenrain): investigate this CI failure.
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
