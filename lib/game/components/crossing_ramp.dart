// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// Indicates a orientation of the ramp entrance/exit.
///
/// Used to know if ramps are looking up or down of the board.
enum RampOrientation {
  /// Looking up of the board.
  up,

  /// Looking up of the board.
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

/// {@template ramp_area}
/// [BodyComponent] located at the entrance and exit of a ramp.
///
/// Detects when a [Ball] goes through it,
/// Collisions with [RampArea] are listened by [RampAreaCallback].
/// {@endtemplate}
abstract class RampArea extends BodyComponent {
  /// {@macro ramp_area}
  RampArea({
    required Vector2 position,
    required int categoryBits,
  })  : _position = position,
        _categoryBits = categoryBits {
    // TODO(ruialonso): remove paint color for BodyComponent.
    // Left white for dev and testing.
  }

  final Vector2 _position;
  final int _categoryBits;

  /// Mask of category bits for collision with [RampArea]
  int get categoryBits => _categoryBits;

  /// The [Shape] of the [RampArea]
  Shape get shape;

  /// Orientation of the [RampArea] entrance/exit
  RampOrientation get orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef).filterData.categoryBits = _categoryBits;

    return body;
  }
}

/// {@template ramp_area_callback}
/// Listens when a [Ball] goes through a [RampArea] and gets into a [Pathway]
/// ramp, in order to avoid collisions with other crossing ramps.
/// Modifies [Ball]'s maskBits while is inside the ramp. When exits sets [Ball]
/// maskBits to collide with all elements.
/// {@endtemplate}
abstract class RampAreaCallback<Area extends RampArea>
    extends ContactCallback<Ball, Area> {
  /// Collection of balls inside ramp pathway.
  Set get ballsInside;

  @override
  void begin(
    Ball ball,
    Area area,
    Contact _,
  ) {
    int maskBits;
    if (!ballsInside.contains(ball)) {
      maskBits = area.categoryBits;
      ballsInside.add(ball);
    } else {
      maskBits = RampType.all.maskBits;
      ballsInside.remove(ball);
    }

    ball.setMaskBits(maskBits);
  }

  @override
  void end(Ball ball, Area area, Contact contact) {
    int? maskBits;

    switch (area.orientation) {
      case RampOrientation.up:
        if (ball.body.position.y > area._position.y) {
          maskBits = RampType.all.maskBits;
        }
        break;
      case RampOrientation.down:
        if (ball.body.position.y < area._position.y) {
          maskBits = RampType.all.maskBits;
        }
        break;
    }

    if (maskBits != null) {
      ball.setMaskBits(maskBits);
    }
  }
}
