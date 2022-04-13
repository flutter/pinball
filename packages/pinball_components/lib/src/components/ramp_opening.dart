// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ramp_orientation}
/// Determines if a ramp is facing [up] or [down] on the Board.
/// {@endtemplate}
enum RampOrientation {
  /// Facing up on the Board.
  up,

  /// Facing down on the Board.
  down,
}

/// {@template ramp_opening}
/// [BodyComponent] located at the entrance and exit of a ramp.
///
/// [RampOpeningBallContactCallback] detects when a [Ball] passes
/// through this opening.
///
/// By default the base [layer] is set to [Layer.board] and the
/// [outsidePriority] is set to the lowest possible [Layer].
/// {@endtemplate}
// TODO(ruialonso): Consider renaming the class.
abstract class RampOpening extends BodyComponent with InitialPosition, Layered {
  /// {@macro ramp_opening}
  RampOpening({
    required Layer insideLayer,
    Layer? outsideLayer,
    required int insidePriority,
    int? outsidePriority,
    required this.orientation,
  })  : _insideLayer = insideLayer,
        _outsideLayer = outsideLayer ?? Layer.board,
        _insidePriority = insidePriority,
        _outsidePriority = outsidePriority ?? Ball.boardPriority {
    layer = Layer.opening;
  }
  final Layer _insideLayer;
  final Layer _outsideLayer;
  final int _insidePriority;
  final int _outsidePriority;

  /// Mask of category bits for collision inside ramp.
  Layer get insideLayer => _insideLayer;

  /// Mask of category bits for collision outside ramp.
  Layer get outsideLayer => _outsideLayer;

  /// Priority for the [Ball] inside ramp.
  int get insidePriority => _insidePriority;

  /// Priority for the [Ball] outside ramp.
  int get outsidePriority => _outsidePriority;

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
/// Detects when a [Ball] enters or exits a ramp through a [RampOpening].
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
      layer = opening.insideLayer;
      _ballsInside.add(ball);
      ball
        ..sendTo(opening.insidePriority)
        ..layer = layer;
    } else {
      _ballsInside.remove(ball);
    }
  }

  @override
  void end(Ball ball, Opening opening, Contact _) {
    if (!_ballsInside.contains(ball)) {
      ball.layer = opening.outsideLayer;
    } else {
      // TODO(ruimiguel): change this code. Check what happens with ball that
      // slightly touch Opening and goes out again. With InitialPosition change
      // now doesn't work position.y comparison
      final isBallOutsideOpening =
          (opening.orientation == RampOrientation.down &&
                  ball.body.linearVelocity.y > 0) ||
              (opening.orientation == RampOrientation.up &&
                  ball.body.linearVelocity.y < 0);

      if (isBallOutsideOpening) {
        ball
          ..sendTo(opening.outsidePriority)
          ..layer = opening.outsideLayer;
        _ballsInside.remove(ball);
      }
    }
  }
}
