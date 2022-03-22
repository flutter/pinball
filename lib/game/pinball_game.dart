// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGame extends Forge2DGame
    with FlameBloc, HasKeyboardHandlerComponents {
  PinballGame({required this.theme});

  final PinballTheme theme;

  late final Plunger plunger;

  static final boardSize = Vector2(72, 128);
  static final boardBounds = Rect.fromCenter(
    center: Offset.zero,
    width: boardSize.x,
    height: -boardSize.y,
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
    unawaited(add(Board()));
    unawaited(_addPlunger());
    unawaited(_addBonusWord());
    unawaited(_addPaths());
    unawaited(addFromBlueprint(Spaceship()));

    // Fix camera on the center of the board.
    camera
      ..followVector2(Vector2.zero())
      ..zoom = size.y / 14;
  }

  void _addContactCallbacks() {
    addContactCallback(BallScorePointsCallback());
    addContactCallback(BottomWallBallContactCallback());
    addContactCallback(BonusLetterBallContactCallback());
  }

  Future<void> _addGameBoundaries() async {
    await add(BottomWall());
    createBoundaries(this).forEach(add);
  }

  Future<void> _addPlunger() async {
    plunger = Plunger(compressionDistance: 2);

    plunger.initialPosition = boardBounds.bottomRight.toVector2() -
        Vector2(
          8,
          -10,
        );
    await add(plunger);
  }

  Future<void> _addBonusWord() async {
    await add(
      BonusWord(
        position: Vector2(
          boardBounds.center.dx,
          boardBounds.bottom + 10,
        ),
      ),
    );
  }

  Future<void> _addPaths() async {
    final jetpackRamp = JetpackRamp(
      position: Vector2(
        PinballGame.boardBounds.left + 25,
        PinballGame.boardBounds.top - 20,
      ),
    );
    final launcherRamp = LauncherRamp(
      position: Vector2(
        PinballGame.boardBounds.right - 23,
        PinballGame.boardBounds.bottom + 40,
      ),
    );

    await addAll([
      jetpackRamp,
      launcherRamp,
    ]);
  }

  void spawnBall() {
    final ball = Ball();
    add(
      ball
        ..initialPosition = plunger.body.position + Vector2(0, ball.size.y / 2),
    );
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
