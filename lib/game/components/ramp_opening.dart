// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// Indicates the orientation of a ramp entrance/exit.
///
/// Used to know if a ramp is facing up or down on the board.
enum RampOrientation {
  /// Facing up on the board.
  up,

  /// Facing down on the board.
  down,
}

/// {@template ramp_opening}
/// [BodyComponent] located at the entrance and exit of a ramp.
///
/// [RampOpeningBallContactCallback] detects when a [Ball] passes
/// through this opening. By default openings are [Layer.board] that
/// means opening are at ground level, not over board.
/// {@endtemplate}
abstract class RampOpening extends BodyComponent with InitialPosition, Layered {
  /// {@macro ramp_opening}
  RampOpening({
    required Layer pathwayLayer,
  }) : _pathwayLayer = pathwayLayer {
    layer = Layer.board;
  }
  final Layer _pathwayLayer;

  /// Mask of category bits for collision inside [Pathway].
  Layer get pathwayLayer => _pathwayLayer;

  /// The [Shape] of the [RampOpening].
  Shape get shape;

  /// Orientation of the [RampOpening] entrance/exit
  // TODO(ruimiguel): Try to remove the need of [RampOrientation] for collision
  // calculations.
  RampOrientation get orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template ramp_opening_ball_contact_callback}
/// Detects when a [Ball] enters or exits a [Pathway] ramp through a
/// [RampOpening].
///
/// Modifies [Ball]'s maskBits while it is inside the ramp. When [Ball] exits,
/// sets maskBits to collide with all elements.
/// {@endtemplate}
class RampOpeningBallContactCallback<Opening extends RampOpening>
    extends ContactCallback<Ball, Opening> {
  /// Collection of balls inside ramp pathway.
  @visibleForTesting
  final ballsInside = <Ball>{};

  @override
  void begin(Ball ball, Opening opening, Contact _) {
    late final Layer layer;
    if (!ballsInside.contains(ball)) {
      layer = opening.pathwayLayer;
      ballsInside.add(ball);
    } else {
      layer = Layer.board;
      ballsInside.remove(ball);
    }

    ball.layer = layer;
  }

  @override
  void end(Ball ball, Opening opening, Contact _) {
    final isBallOutsideOpening = opening.orientation == RampOrientation.up
        ? ball.body.position.y > opening.body.position.y
        : ball.body.position.y < opening.body.position.y;

    if (isBallOutsideOpening) ball.layer = Layer.board;
  }
}
