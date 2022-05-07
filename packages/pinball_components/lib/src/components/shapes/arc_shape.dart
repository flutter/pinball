// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:geometry/geometry.dart';

/// {@template arc_shape}
/// Creates an arc.
/// {@endtemplate}
class ArcShape extends ChainShape {
  /// {@macro arc_shape}
  ArcShape({
    required this.center,
    required this.arcRadius,
    required this.angle,
    this.rotation = 0,
  }) {
    createChain(
      calculateArc(
        center: center,
        radius: arcRadius,
        angle: angle,
        offsetAngle: rotation,
      ),
    );
  }

  /// The center of the arc.
  final Vector2 center;

  /// The radius of the arc.
  final double arcRadius;

  /// Specifies the size of the arc, in radians.
  ///
  /// For example, two pi returns a complete circumference.
  final double angle;

  /// Angle in radians to rotate the arc around its [center].
  final double rotation;

  ArcShape copyWith({
    Vector2? center,
    double? arcRadius,
    double? angle,
    double? rotation,
  }) =>
      ArcShape(
        center: center ?? this.center,
        arcRadius: arcRadius ?? this.arcRadius,
        angle: angle ?? this.angle,
        rotation: rotation ?? this.rotation,
      );
}
