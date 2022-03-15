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

    unawaited(_addFlippers());

    unawaited(_addBonusWord());
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

  Future<void> _addFlippers() async {
    final flippersPosition = screenToWorld(
      Vector2(
        camera.viewport.effectiveSize.x / 2,
        camera.viewport.effectiveSize.y / 1.1,
      ),
    );

    unawaited(
      add(
        FlipperGroup(
          position: flippersPosition,
          spacing: 2,
        ),
      ),
    );
    unawaited(_addBaseboards());
  }

  void spawnBall() {
    add(Ball(position: plunger.body.position));
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

  Future<void> _addPlunger() async {
    final compressionDistance = camera.viewport.effectiveSize.y / 12;

    await add(
      plunger = Plunger(
        position: screenToWorld(
          Vector2(
            camera.viewport.effectiveSize.x / 1.035,
            camera.viewport.effectiveSize.y - compressionDistance,
          ),
        ),
        compressionDistance: compressionDistance,
      ),
    );
  }

  Future<void> _addBaseboards() async {
    final spaceBetweenBaseboards = camera.viewport.effectiveSize.x / 2;
    final baseboardY = camera.viewport.effectiveSize.y / 1.12;

    final leftBaseboard = Baseboard.left(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 - (spaceBetweenBaseboards / 2),
          baseboardY,
        ),
      ),
    );
    await add(leftBaseboard);

    final rightBaseboard = Baseboard.right(
      position: screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2 + (spaceBetweenBaseboards / 2),
          baseboardY,
        ),
      ),
    );
    await add(rightBaseboard);
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  void onTapUp(TapUpInfo info) {
    add(Ball(position: info.eventPosition.game));
  }
}
