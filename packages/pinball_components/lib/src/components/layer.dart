import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// {@template layered}
/// Modifies maskBits and categoryBits of all the [BodyComponent]'s [Fixture]s
/// to specify what other [BodyComponent]s it can collide with.
///
/// [BodyComponent]s with compatible [Layer]s can collide with each other,
/// ignoring others. This compatibility depends on bit masking operation
/// between layers. For more information read: https://en.wikipedia.org/wiki/Mask_(computing).
///
/// A parent [Layered] have priority against its children's layer. Them won't be
/// changed but will be ignored.
/// {@endtemplate}
mixin Layered<T extends Forge2DGame> on BodyComponent<T> {
  Layer _layer = Layer.all;

  /// {@macro layered}
  Layer get layer => _layer;

  set layer(Layer value) {
    _layer = value;
    if (!isLoaded) {
      loaded.whenComplete(_applyMaskBits);
    } else {
      _applyMaskBits();
    }
  }

  void _applyMaskBits() {
    for (final fixture in body.fixtures) {
      fixture
        ..filterData.categoryBits = layer.maskBits
        ..filterData.maskBits = layer.maskBits;
    }
  }
}

/// The [Layer]s a [BodyComponent] can be in.
///
/// Each [Layer] is associated with a maskBits value to define possible
/// collisions within that plane.
///
/// Usually used with [Layered].
enum Layer {
  /// Collide with all elements.
  all,

  /// Collide only with board elements (the ground level).
  board,

  /// Collide only with ramps opening elements.
  opening,

  /// Collide only with Spaceship entrance ramp group elements.
  spaceshipEntranceRamp,

  /// Collide only with Launcher group elements.
  launcher,

  /// Collide only with Spaceship group elements.
  spaceship,

  /// Collide only with Spaceship exit rail group elements.
  spaceshipExitRail,
}

/// {@template layer_mask_bits}
/// Specifies the maskBits of each [Layer].
///
/// Used by [Layered] to specify what other [BodyComponent]s it can collide
///
/// Note: the maximum value for maskBits is 2^16.
/// {@endtemplate}
@visibleForTesting
extension LayerMaskBits on Layer {
  /// {@macro layer_mask_bits}
  @visibleForTesting
  int get maskBits {
    // TODO(ruialonso): test bit groups once final design is implemented.
    switch (this) {
      case Layer.all:
        return 0xFFFF;
      case Layer.board:
        return 0x0001;
      case Layer.opening:
        return 0x0007;
      case Layer.spaceshipEntranceRamp:
        return 0x0002;
      case Layer.launcher:
        return 0x0008;
      case Layer.spaceship:
        return 0x000A;
      case Layer.spaceshipExitRail:
        return 0x0004;
    }
  }
}
