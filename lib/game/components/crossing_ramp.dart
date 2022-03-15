// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template layer}
/// Modifies maskBits of [BodyComponent] for collisions.
///
/// Changes the [Filter] data for category and maskBits of
/// the [BodyComponent] to collide with other objects of
/// same bits and ignore others.
/// {@endtemplate}
mixin Layer on BodyComponent<PinballGame> {
  void setLayer(RampType layer) {
    for (final fixture in body.fixtures) {
      fixture
        ..filterData.categoryBits = layer.maskBits
        ..filterData.maskBits = layer.maskBits;
    }
  }
}

/// Indicates a orientation of the ramp entrance/exit.
///
/// Used to know if ramps are looking up or down of the board.
enum RampOrientation {
  /// Looking up of the board.
  up,

  /// Looking down of the board.
  down,
}

/// Indicates a type of the ramp.
///
/// Used to set the maskBits of the ramp to determine their possible collisions.
enum RampType {
  /// Collide with all elements.
  all,

  /// Collide only with Jetpack group elements.
  jetpack,

  /// Collide only with Sparky group elements.
  sparky,
}

/// Utility methods for [RampType].
extension RampTypeX on RampType {
  /// Mask of bits for each [RampType].
  int get maskBits => _getRampMaskBits(this);

  /// Mask of bits for each [RampType].
  int _getRampMaskBits(RampType type) {
    switch (type) {
      case RampType.all:
        return Filter().maskBits;
      case RampType.jetpack:
        return 0x010;
      case RampType.sparky:
        return 0x0100;
    }
  }
}

/// {@template ramp_opening}
/// [BodyComponent] located at the entrance and exit of a ramp.
///
/// [RampOpeningBallContactCallback] detects when a [Ball] passes
/// through this opening.
/// Collisions with [RampOpening] are listened
/// by [RampOpeningBallContactCallback].
/// {@endtemplate}
abstract class RampOpening extends BodyComponent {
  /// {@macro ramp_opening}
  RampOpening({
    required Vector2 position,
    required RampType layer,
  })  : _position = position,
        _layer = layer {
    // TODO(ruialonso): remove paint color for BodyComponent.
    // Left white for dev and testing.
  }

  final Vector2 _position;
  final RampType _layer;

  /// Mask of category bits for collision with [RampOpening]
  RampType get layer => _layer;

  /// The [Shape] of the [RampOpening]
  Shape get shape;

  /// Orientation of the [RampOpening] entrance/exit
  RampOrientation get orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true
      ..filter.categoryBits = _layer.maskBits;

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
/// Modifies [Ball]'s maskBits while is inside the ramp. When [Ball] exits,
/// sets maskBits to collide with all elements.
/// {@endtemplate}
abstract class RampOpeningBallContactCallback<Area extends RampOpening>
    extends ContactCallback<Ball, Area> {
  /// Collection of balls inside ramp pathway.
  Set get ballsInside;

  @override
  void begin(
    Ball ball,
    Area area,
    Contact _,
  ) {
    RampType layer;
    if (!ballsInside.contains(ball)) {
      layer = area.layer;
      ballsInside.add(ball);
    } else {
      layer = RampType.all;
      ballsInside.remove(ball);
    }

    ball.setLayer(layer);
  }

  @override
  void end(Ball ball, Area area, Contact contact) {
    RampType? layer;

    switch (area.orientation) {
      case RampOrientation.up:
        if (ball.body.position.y > area._position.y) {
          layer = RampType.all;
        }
        break;
      case RampOrientation.down:
        if (ball.body.position.y < area._position.y) {
          layer = RampType.all;
        }
        break;
    }

    if (layer != null) {
      ball.setLayer(layer);
    }
  }
}
