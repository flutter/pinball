// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGame extends Forge2DGame
    with FlameBloc, HasKeyboardHandlerComponents {
  PinballGame({required this.theme});

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
    unawaited(_addPlunger());
    unawaited(_addPaths());

    unawaited(_addSpaceship());

    // Corner wall above plunger so the ball deflects into the rest of the
    // board.
    // TODO(allisonryan0002): remove once we have the launch track for the ball.
    await add(
      Wall(
        start: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x,
            100,
          ),
        ),
        end: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x - 100,
            0,
          ),
        ),
      ),
    );

    unawaited(_addBonusWord());
    unawaited(_addBoard());
  }

  Future<void> _addBoard() async {
    final board = Board(
      size: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x,
          camera.viewport.effectiveSize.y,
        ),
      ),
    );
    await add(board);
  }

  Future<void> _addBonusWord() async {
    await add(
      BonusWord(
        position: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x / 2,
            camera.viewport.effectiveSize.y - 50,
          ),
        ),
      ),
    );
  }

  Future<void> _addSpaceship() async {
    final position = Vector2(20, -24);
    await addAll(
      [
        SpaceshipSaucer()..initialPosition = position,
        SpaceshipEntrance()..initialPosition = position,
        SpaceshipBridge()..initialPosition = position,
        SpaceshipBridgeTop()..initialPosition = position + Vector2(0, 5.5),
        SpaceshipHole()..initialPosition = position - Vector2(5, 4),
        SpaceshipHole()..initialPosition = position - Vector2(-5, 4),
        SpaceshipWall()..initialPosition = position,
      ],
    );
  }

  void spawnBall() {
    final ball = Ball();
    add(
      ball
        ..initialPosition = plunger.body.position + Vector2(0, ball.size.y / 2),
    );
  }

  void _addContactCallbacks() {
    addContactCallback(BallScorePointsCallback());
    addContactCallback(BottomWallBallContactCallback());
    addContactCallback(BonusLetterBallContactCallback());
    addContactCallback(SpaceshipHoleBallContactCallback());
    addContactCallback(SpaceshipEntranceBallContactCallback());
  }

  Future<void> _addGameBoundaries() async {
    await add(BottomWall(this));
    createBoundaries(this).forEach(add);
  }

  Future<void> _addPaths() async {
    final jetpackRamp = JetpackRamp(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 - 150,
          camera.viewport.effectiveSize.y / 2 - 250,
        ),
      ),
    );
    final launcherRamp = LauncherRamp(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 + 400,
          camera.viewport.effectiveSize.y / 2 - 330,
        ),
      ),
    );

    await addAll([jetpackRamp, launcherRamp]);
  }

  Future<void> _addPlunger() async {
    plunger = Plunger(
      compressionDistance: camera.viewport.effectiveSize.y / 12,
    );
    plunger.initialPosition = screenToWorld(
      Vector2(
        camera.viewport.effectiveSize.x / 2 + 450,
        camera.viewport.effectiveSize.y - plunger.compressionDistance,
      ),
    );

    await add(plunger);
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball()..initialPosition = info.eventPosition.game,
    );
  }
}
