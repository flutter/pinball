// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// Modifies maskBits of [BodyComponent] to control what other bodies it can
/// have physical interactions with.
///
/// Changes the [Filter] data for category and maskBits of the [BodyComponent]
/// so it will only collide with bodies having the same bit value and ignore
/// bodies with a different bit value.
/// {@endtemplate}
mixin Layered<T extends Forge2DGame> on BodyComponent<T> {
  /// Sets [Filter] category and mask bits for the [BodyComponent]
  set layer(Layer layer) {
    for (final fixture in body.fixtures) {
      fixture
        ..filterData.categoryBits = layer.maskBits
        ..filterData.maskBits = layer.maskBits;
    }
  }
}

/// Indicates the type of a layer.
///
/// Each layer type is associated with a maskBits value to define possible
/// collisions within that plane.
enum Layer {
  /// Collide with all elements.
  all,

  /// Collide only with board elements (the ground level).
  board,

  /// Collide only with ramps opening elements.
  opening,

  /// Collide only with Jetpack group elements.
  jetpack,

  /// Collide only with Launcher group elements.
  launcher,
}

/// Utility methods for [Layer].
extension LayerX on Layer {
  /// Mask of bits for each [Layer] to filter collisions.
  int get maskBits {
    switch (this) {
      case Layer.all:
        return 0xFFFF;
      case Layer.board:
        return 0x0001;
      case Layer.opening:
        return 0x0007;
      case Layer.jetpack:
        return 0x0002;
      case Layer.launcher:
        return 0x0005;
    }
  }
}

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
abstract class RampOpening extends BodyComponent {
  /// {@macro ramp_opening}
  RampOpening({
    required Vector2 position,
    required Layer pathwayLayer,
    Layer? openingLayer,
  })  : _position = position,
        _pathwayLayer = pathwayLayer,
        _openingLayer = openingLayer ?? Layer.board {
    // TODO(ruialonso): remove paint color for BodyComponent.
    // Left white for dev and testing.
  }

  final Vector2 _position;
  final Layer _openingLayer;
  final Layer _pathwayLayer;

  /// Mask of category bits for collision with [RampOpening]
  Layer get openingLayer => _openingLayer;

  /// Mask of category bits for collision inside [Pathway]
  Layer get pathwayLayer => _pathwayLayer;

  /// The [Shape] of the [RampOpening]
  Shape get shape;

  /// Orientation of the [RampOpening] entrance/exit
  RampOrientation get orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true
      ..filter.categoryBits = _openingLayer.maskBits;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
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
abstract class RampOpeningBallContactCallback<Opening extends RampOpening>
    extends ContactCallback<Ball, Opening> {
  /// Collection of balls inside ramp pathway.
  Set get ballsInside;

  @override
  void begin(
    Ball ball,
    Opening opening,
    Contact _,
  ) {
    Layer layer;
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
  void end(Ball ball, Opening opening, Contact contact) {
    Layer? layer;

    switch (opening.orientation) {
      case RampOrientation.up:
        if (ball.body.position.y > opening._position.y) {
          layer = Layer.board;
        }
        break;
      case RampOrientation.down:
        if (ball.body.position.y < opening._position.y) {
          layer = Layer.board;
        }
        break;
    }

    if (layer != null) {
      ball.layer = layer;
    }
  }
}
