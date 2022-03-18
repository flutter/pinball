// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template ramp_orientation}
/// Determines if a ramp is facing [up] or [down] on the [Board].
/// {@endtemplate}
enum RampOrientation {
  /// Facing up on the [Board].
  up,

  /// Facing down on the [Board].
  down,
}

/// {@template ramp_opening}
/// [BodyComponent] located at the entrance and exit of a ramp.
///
/// [RampOpeningBallContactCallback] detects when a [Ball] passes
/// through this opening.
///
/// By default the base [layer] is set to [Layer.board].
/// {@endtemplate}
// TODO(ruialonso): Consider renaming the class.
abstract class RampOpening extends BodyComponent with InitialPosition, Layered {
  /// {@macro ramp_opening}
  RampOpening({
    required Layer pathwayLayer,
    required this.orientation,
  }) : _pathwayLayer = pathwayLayer {
    layer = Layer.board;
  }
  final Layer _pathwayLayer;

  /// Mask of category bits for collision inside [Pathway].
  Layer get pathwayLayer => _pathwayLayer;

  /// The [Shape] of the [RampOpening].
  Shape get shape;

  /// {@macro ramp_orientation}
  // TODO(ruimiguel): Try to remove the need of [RampOrientation] for collision
  // calculations.
  final RampOrientation orientation;

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
/// Modifies [Ball]'s [Layer] accordingly depending on whether the [Ball] is
/// outside or inside a ramp.
/// {@endtemplate}
class RampOpeningBallContactCallback<Opening extends RampOpening>
    extends ContactCallback<Ball, Opening> {
  /// [Ball]s currently inside the ramp.
  final _ballsInside = <Ball>{};

  @override
  void begin(Ball ball, Opening opening, Contact _) {
    Layer layer;

    if (!_ballsInside.contains(ball)) {
      layer = opening.pathwayLayer;
      _ballsInside.add(ball);
      ball.layer = layer;
    } else {
      _ballsInside.remove(ball);
    }
  }

  @override
  void end(Ball ball, Opening opening, Contact _) {
    if (!_ballsInside.contains(ball)) {
      ball.layer = Layer.board;
    } else {
      // TODO(ruimiguel): change this code. Check what happens with ball that
      // slightly touch Opening and goes out again. With InitialPosition change
      // now doesn't work position.y comparison
      final isBallOutsideOpening =
          (opening.orientation == RampOrientation.down &&
                  ball.body.linearVelocity.y < 0) ||
              (opening.orientation == RampOrientation.up &&
                  ball.body.linearVelocity.y > 0);

      if (isBallOutsideOpening) {
        ball.layer = Layer.board;
        _ballsInside.remove(ball);
      }
    }
  }
}
