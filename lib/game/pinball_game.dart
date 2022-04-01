// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

class PinballGame extends Forge2DGame
    with FlameBloc, HasKeyboardHandlerComponents {
  PinballGame({required this.theme}) {
    images.prefix = '';
  }

  final PinballTheme theme;

  late final Plunger plunger;

  @override
  void onAttach() {
    super.onAttach();
    spawnBall();
  }

  @override
  Future<void> onLoad() async {
    _addContactCallbacks();

    await _addGameBoundaries();
    unawaited(add(Board()));
    unawaited(_addPlunger());
    unawaited(_addBonusWord());
    unawaited(_addPaths());
    unawaited(
      addFromBlueprint(
        Spaceship(
          position: Vector2(-26.5, 28.5),
        ),
      ),
    );
    unawaited(
      addFromBlueprint(
        SpaceshipExitRail(
          position: Vector2(-34.3, 23.8),
        ),
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
    unawaited(
      addFromBlueprint(
        DinoWalls(
          position: Vector2(-2.4, 0),
        ),
      ),
    );
  }

  Future<void> _addPlunger() async {
    plunger = Plunger(compressionDistance: 29)
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

  Future<void> _addPaths() async {
    unawaited(addFromBlueprint(Jetpack()));
    unawaited(addFromBlueprint(Launcher()));
  }

  void spawnBall() {
    final ball = ControlledBall.launch(
      theme: theme,
    )..initialPosition = Vector2(
        plunger.body.position.x,
        plunger.body.position.y + Ball.size.y,
      );
    add(ball);
  }
}

class DebugPinballGame extends PinballGame with TapDetector, PanDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  Vector2? lineStart;
  Vector2? lineEnd;

  @override
  Future<void> onLoad() async {
    unawaited(add(PreviewLine()));

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
      ..priority = -1;

    await add(spriteComponent);
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      ControlledBall.debug()..initialPosition = info.eventPosition.game,
    );
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
    add(ball);

    ball.mounted.then((value) => ball.boost(line * 20));
  }
}

class PreviewLine extends PositionComponent with HasGameRef<DebugPinballGame> {
  static final _previewLinePaint = Paint()
    ..color = Colors.pink
    ..strokeWidth = 0.2
    ..style = PaintingStyle.stroke;

  Vector2? lineStart;
  Vector2? lineEnd;

  @override
  void update(double dt) {
    super.update(dt);

    lineEnd = gameRef.lineEnd?.clone()?..multiply(Vector2(1, -1));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (lineEnd != null) {
      lineStart = gameRef.lineStart?.clone()?..multiply(Vector2(1, -1));

      canvas.drawLine(
        lineStart!.toOffset(),
        lineEnd!.toOffset(),
        _previewLinePaint,
      );
    }
  }
}
