import 'dart:async';

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with FlameBloc {
  void spawnBall() {
    add(
      Ball(position: ballStartingPosition),
    );
  }

  // TODO(erickzanardo): Change to the plumber position
  late final ballStartingPosition = screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y - 20,
        ),
      ) -
      Vector2(0, -20);

  @override
  Future<void> onLoad() async {
    addContactCallback(BallScorePointsCallback());

    await add(BottomWall(this));
    addContactCallback(BottomWallBallContactCallback());
  }

  @override
  void onAttach() {
    super.onAttach();
    spawnBall();
  }
}
