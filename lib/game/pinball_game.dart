// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame
    with FlameBloc, HasKeyboardHandlerComponents {
  // TODO(erickzanardo): Change to the plumber position
  late final ballStartingPosition = screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y - 20,
        ),
      ) -
      Vector2(0, -20);

  // TODO(alestiago): Change to the design position.
  late final flippersPosition = ballStartingPosition - Vector2(0, 5);

  @override
  void onAttach() {
    super.onAttach();
    spawnBall();
  }

  void spawnBall() {
    add(Ball(position: ballStartingPosition));
  }

  @override
  Future<void> onLoad() async {
    addContactCallback(BallScorePointsCallback());

    await add(BottomWall(this));
    addContactCallback(BottomWallBallContactCallback());

    unawaited(
      add(
        FlipperGroup(
          position: flippersPosition,
          spacing: 2,
        ),
      ),
    );
  }
}
