// ignore_for_file: public_member_api_docs

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:geometry/geometry.dart';

/// {@template ellipse_shape}
/// Creates an ellipse.
/// {@endtemplate}
class EllipseShape extends ChainShape {
  /// {@macro ellipse_shape}
  EllipseShape({
    required this.center,
    required this.majorRadius,
    required this.minorRadius,
    this.rotation = 0,
  }) {
    final points = calculateEllipse(
      center: center,
      majorRadius: majorRadius,
      minorRadius: minorRadius,
    );
    if (rotation != 0) {
      points.map((vector) => vector..rotate(rotation)).toList();
    }
    createChain(points);
  }

  /// The top left corner of the ellipse.
  ///
  /// Where the initial painting begins.
  // TODO(ruialonso): Change to use appropiate center.
  final Vector2 center;

  /// Major radius is specified by [majorRadius].
  final double majorRadius;

  /// Minor radius is specified by [minorRadius].
  final double minorRadius;

  /// Which can be rotated by a given [rotation] in radians.
  final double rotation;

  EllipseShape copyWith({
    Vector2? center,
    double? majorRadius,
    double? minorRadius,
    double? rotation,
  }) =>
      EllipseShape(
        center: center ?? this.center,
        majorRadius: majorRadius ?? this.majorRadius,
        minorRadius: minorRadius ?? this.minorRadius,
        rotation: rotation ?? this.rotation,
      );
}
