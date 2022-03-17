import 'package:flame_forge2d/flame_forge2d.dart';

/// Modifies maskBits of [BodyComponent] to control what other bodies it can
/// have physical interactions with.
///
/// Changes the [Filter] data for category and maskBits of the [BodyComponent]
/// so it will only collide with bodies having the same bit value and ignore
/// bodies with a different bit value.
/// {@endtemplate}
mixin Layered<T extends Forge2DGame> on BodyComponent<T> {
  Layer _layer = Layer.all;

  /// Sets [Filter] category and mask bits for the [BodyComponent].
  Layer get layer => _layer;

  set layer(Layer value) {
    _layer = value;
    if (!isLoaded) {
      // TODO(alestiago): Use loaded.whenComplete once provided.
      mounted.whenComplete(() => layer = value);
    } else {
      for (final fixture in body.fixtures) {
        fixture
          ..filterData.categoryBits = layer.maskBits
          ..filterData.maskBits = layer.maskBits;
      }
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
