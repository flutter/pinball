// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class BallWallContactCallback extends ContactCallback<Ball, Wall> {
  @override
  void begin(Ball ball, Wall wall, Contact contact) {
    ball.shouldRemove = true;
  }

  @override
  void end(_, __, ___) {}
}

class PinballGame extends Forge2DGame with FlameBloc {
  void resetBall() {
    add(Ball(position: ballStartingPosition));
  }

  late final ballStartingPosition = screenToWorld(
        Vector2(
          camera.viewport.effectiveSize.x / 2,
          camera.viewport.effectiveSize.y - 20,
        ),
      ) -
      Vector2(
        0,
        -20,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addContactCallback(BallScorePointsCallback());

    final topLeft = Vector2.zero();
    final bottomRight = screenToWorld(camera.viewport.effectiveSize);
    final bottomLeft = Vector2(topLeft.x, bottomRight.y);

    await add(
      Wall(bottomRight, bottomLeft),
    );
    addContactCallback(BallWallContactCallback());

    resetBall();
  }
}
