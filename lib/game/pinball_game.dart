// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

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
  static final boardPerspectiveAngle =
      -math.atan(18.6 / PinballGame.boardBounds.height);

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
      ..followVector2(Vector2(0, -7.8))
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
    plunger = Plunger(compressionDistance: 29)
      ..initialPosition = boardBounds.center.toVector2() + Vector2(41.5, -49);
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
    unawaited(addFromBlueprint(Jetpack()));
    unawaited(addFromBlueprint(Launcher()));
  }

  void spawnBall() {
    addFromBlueprint(
      BallBlueprint(
        position: plunger.body.position,
        type: BallType.normal,
      ),
    );
  }
}

class DebugPinballGame extends PinballGame with TapDetector {
  DebugPinballGame({required PinballTheme theme}) : super(theme: theme);

  @override
  Future<void> onLoad() async {
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
    addFromBlueprint(
      BallBlueprint(
        position: info.eventPosition.game,
        type: BallType.extra,
      ),
    );
  }
}
