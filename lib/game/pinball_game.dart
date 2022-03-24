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
  PinballGame({required this.theme}) {
    images.prefix = '';
  }

  final PinballTheme theme;

  late final Plunger plunger;

  static final boardSize = Vector2(101.6, 143.8);
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
      ..zoom = size.y / 16;
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

    plunger.initialPosition = boardBounds.bottomRight.toVector2() +
        Vector2(
          -5,
          10,
        );
    await add(plunger);
  }

  Future<void> _addBonusWord() async {
    await add(
      BonusWord(
        position: Vector2(
          boardBounds.center.dx - 3.07,
          boardBounds.center.dy - 2.4,
        ),
      ),
    );
  }

  Future<void> _addPaths() async {
    final jetpackRamp = JetpackRamp(
      position: Vector2(
        PinballGame.boardBounds.left + 40.5,
        PinballGame.boardBounds.top - 31.5,
      ),
    );
    final launcherRamp = LauncherRamp(
      position: Vector2(
        PinballGame.boardBounds.right - 30,
        PinballGame.boardBounds.bottom + 40,
      ),
    );

    await addAll([
      jetpackRamp,
      launcherRamp,
    ]);
  }

  void spawnBall() {
    addFromBlueprint(BallBlueprint(position: plunger.body.position));
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  void onTapUp(TapUpInfo info) {
    addFromBlueprint(BallBlueprint(position: info.eventPosition.game));
  }
}
