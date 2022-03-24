// ignore_for_file: public_member_api_docs
// TODO(alestiago): Move this file to an appropriate location.

import 'package:flame/extensions.dart';
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
    required this.rotation,
  }) {
    createChain(
      calculateArc(
        center: center,
        radius: radius,
        angle: angle,
        offsetAngle: rotation,
      ),
    );
  }

  /// The center of the arc.
  final Vector2 center;

  /// The radius of the arc.
  // TODO(alestiago): Check if modifying the parent radius makes sense.
  final double arcRadius;

  /// Specifies the size of the arc, in radians.
  ///
  /// For example, two pi returns a complete circumference.
  final double angle;

  /// Which can be rotated by a given [rotation] in radians.
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

/// {@template bezier_curve_shape}
/// Creates a bezier curve.
/// {@endtemplate}
class BezierCurveShape extends ChainShape {
  /// {@macro bezier_curve_shape}
  BezierCurveShape({
    required this.controlPoints,
  }) {
    createChain(
      calculateBezierCurve(controlPoints: controlPoints),
    );
  }

  /// Specifies the control points of the curve.
  ///
  /// First and last [controlPoints] set the beginning and end of the curve,
  /// inner points between them set its final shape.
  final List<Vector2> controlPoints;

  /// Rotates the curve by a given [angle] in radians.
  void rotate(double angle) {
    vertices.map((vector) => vector..rotate(angle)).toList();
  }
}

/// {@template ellipse_shape}
/// Creates an ellipse.
/// {@endtemplate}
class EllipseShape extends ChainShape {
  /// {@macro ellipse_shape}
  EllipseShape({
    required this.center,
    required this.majorRadius,
    required this.minorRadius,
  }) {
    createChain(
      calculateEllipse(
        center: center,
        majorRadius: majorRadius,
        minorRadius: minorRadius,
      ),
    );
  }

  /// The top left corner of the ellipse.
  ///
  /// Where the initial painting begines.
  // TODO(ruialonso): Change to use appropiate center.
  final Vector2 center;

  /// Major radius is specified by [majorRadius].
  final double majorRadius;

  /// Minor radius is specified by [minorRadius].
  final double minorRadius;

  /// Rotates the ellipse by a given [angle] in radians.
  void rotate(double angle) {
    createChain(
      vertices.map((vector) => vector..rotate(angle)).toList(),
    );
  }

  EllipseShape copyWith({
    Vector2? center,
    double? majorRadius,
    double? minorRadius,
  }) =>
      EllipseShape(
        center: center ?? this.center,
        majorRadius: majorRadius ?? this.majorRadius,
        minorRadius: minorRadius ?? this.minorRadius,
      );
}
