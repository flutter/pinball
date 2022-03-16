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

  late final launcherRampPosition = screenToWorld(
    Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y / 2,
        ) +
        Vector2(373, -155),
  );
  late final jetpackRampPosition = screenToWorld(
    Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y / 2,
        ) +
        Vector2(-150, -150),
  );

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
    unawaited(
      add(
        BottomGroup(
          position: screenToWorld(
            Vector2(
              camera.viewport.effectiveSize.x / 2,
              camera.viewport.effectiveSize.y / 1.25,
            ),
          ),
          spacing: 2,
        ),
      ),
    );
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
  }

  Future<void> _addGameBoundaries() async {
    await add(BottomWall(this));
    createBoundaries(this).forEach(add);
  }

  Future<void> _addPaths() async {
    await add(
      JetpackRamp(
        position: jetpackRampPosition,
      ),
    );

    await add(
      LauncherRamp(
        position: launcherRampPosition,
      ),
    );
  }

  Future<void> _addPlunger() async {
    plunger = Plunger(
      compressionDistance: camera.viewport.effectiveSize.y / 12,
    );
    plunger.initialPosition = screenToWorld(
      Vector2(
        camera.viewport.effectiveSize.x / 1.035,
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
