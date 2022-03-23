// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';

class SpaceshipDropRamp extends Forge2DBlueprint {
  @override
  void build() {
    final position = Vector2(
      PinballGame.boardBounds.left + 22,
      PinballGame.boardBounds.center.dy + 27,
    );

    addAllContactCallback([
      SpaceshipDropHoleBallContactCallback(),
    ]);

    final curvedPath = Pathway.bezierCurve(
      color: const Color.fromARGB(255, 226, 226, 218),
      width: 4,
      rotation: 230 * math.pi / 180,
      controlPoints: [
        Vector2(0, 0),
        Vector2(0, 30),
        Vector2(30, 0),
        Vector2(30, 30),
      ],
    )..layer = Layer.spaceshipDrop;

    final curvedEntrance = Pathway.arc(
      color: const Color.fromARGB(255, 226, 226, 218),
      center: position,
      radius: 4,
      angle: math.pi / 2,
      width: 5,
      rotation: 218 * math.pi / 180,
      singleWall: true,
    )..layer = Layer.spaceshipDrop;

    final curvedExit = Pathway.arc(
      color: const Color.fromARGB(255, 226, 226, 218),
      center: position,
      radius: 4,
      angle: math.pi / 2,
      width: 5,
      rotation: 36 * math.pi / 180,
      singleWall: true,
    )..layer = Layer.spaceshipDrop;

    addAll([
      curvedPath..initialPosition = position,
      curvedEntrance..initialPosition = position + Vector2(26.5, -30),
      curvedExit..initialPosition = position + Vector2(29, -66.5),
      SpaceshipDropHole()..initialPosition = position + Vector2(0, -42),
    ]);
  }
}

/// {@template spaceship_drop_hole}
/// A sensor [BodyComponent] responsible for sending the [Ball]
/// back to the board.
/// {@endtemplate}
class SpaceshipDropHole extends RampOpening {
  /// {@macro spaceship_drop_hole}
  SpaceshipDropHole()
      : super(
          pathwayLayer: Layer.spaceshipDrop,
          orientation: RampOrientation.down,
        ) {
    layer = Layer.spaceshipDrop;
  }

  @override
  Shape get shape {
    return CircleShape()..radius = Spaceship.radius / 40;
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipDropHole].
///
/// It resets the [Ball] priority and filter data so it will "be back" on the
/// board.
class SpaceshipDropHoleBallContactCallback
    extends ContactCallback<SpaceshipDropHole, Ball> {
  @override
  void begin(SpaceshipDropHole hole, Ball ball, _) {
    ball
      ..priority = 1
      ..gameRef.reorderChildren()
      ..layer = hole.outsideLayer;
  }
}
