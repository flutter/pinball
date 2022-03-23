import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// {@template elevated}
/// Modifies priority of the [BodyComponent] to specify in which z-index level
///  [BodyComponent] is.
/// {@endtemplate}
mixin Elevated<T extends Forge2DGame> on BodyComponent<T> {
  int _elevation = Elevation.board.order;

  /// {@macro elevated}
  int get elevation => _elevation;

  set elevation(int value) {
    _elevation = value;
    if (!isLoaded) {
      // TODO(ruimiguel): Use loaded.whenComplete once provided.
      mounted.whenComplete(_applyElevation);
    } else {
      _applyElevation();
    }
  }

  void _applyElevation() {
    priority = elevation;
    reorderChildren();
  }

  void _applyCustomElevation(int customElevation) {
    priority = customElevation;
    reorderChildren();
  }
}

/// The [Elevation]s a [BodyComponent] can be in.
///
/// Each [Elevation] is associated with a different board level from ground, to
/// define several z-index heights.
///
/// Usually used with [Elevated].
enum Elevation {
  /// The ground level.
  board,

  /// Level for Jetpack group elements.
  jetpack,

  /// Level for Spaceship group elements.
  spaceship,

  /// Level for SpaceshipExitRail.
  spaceshipExitRail,
}

/// {@template elevation_order}
/// Specifies the order of each [Elevation].
///
/// Used by [Elevated] to specify what is the priority of [BodyComponent].
/// {@endtemplate}
@visibleForTesting
extension ElevationOrder on Elevation {
  /// {@macro elevation_order}

  int get order {
    switch (this) {
      case Elevation.board:
        return 1;
      case Elevation.jetpack:
        return 2;
      case Elevation.spaceship:
        return 3;
      case Elevation.spaceshipExitRail:
        return 2;
    }
  }
}
