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
    late PlungerAnchor plungerAnchor;
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
    await add(plungerAnchor = PlungerAnchor(plunger: plunger));

    world.createJoint(
      PlungerAnchorPrismaticJointDef(
        plunger: plunger,
        anchor: plungerAnchor,
      ),
    );
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  void onTapUp(TapUpInfo info) {
    add(Ball(position: info.eventPosition.game));
  }
}
