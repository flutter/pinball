import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';

class SpaceshipDropRamp extends Forge2DBlueprint {
  @override
  void build() {
    final position = Vector2(
      PinballGame.boardBounds.left + 23,
      PinballGame.boardBounds.center.dy + 25,
    );

    addAllContactCallback([
      SpaceshipHoleBallContactCallback(),
      SpaceshipEntranceBallContactCallback(),
    ]);

    final curvedPath = Pathway.bezierCurve(
      color: Color.fromARGB(255, 226, 226, 218),
      width: 5,
      rotation: 230 * math.pi / 180,
      controlPoints: [
        Vector2(0, 0),
        Vector2(0, 30),
        Vector2(30, 0),
        Vector2(30, 30),
      ],
    )..layer = Layer.spaceship_drop;

    addAll([
      curvedPath..initialPosition = position,
    ]);
  }
}

class SpaceshipRampEntrance extends RampOpening {
  /// {@macro spaceship_ramp_entrance}
  SpaceshipRampEntrance()
      : super(
          pathwayLayer: Layer.spaceship_drop,
          orientation: RampOrientation.up,
        ) {
    layer = Layer.spaceship_drop;
  }

  @override
  Shape get shape {
    const radius = Spaceship.radius * 2;
    return PolygonShape();
  }
}

class SpaceshipRampExit extends RampOpening {
  /// {@macro spaceship_ramp_entrance}
  SpaceshipRampExit()
      : super(
          pathwayLayer: Layer.spaceship_drop,
          orientation: RampOrientation.down,
        ) {
    layer = Layer.spaceship_drop;
  }

  @override
  Shape get shape {
    const radius = Spaceship.radius * 2;
    return PolygonShape();
  }
}
