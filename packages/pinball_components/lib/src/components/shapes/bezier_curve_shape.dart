// ignore_for_file: public_member_api_docs

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:geometry/geometry.dart';

/// {@template bezier_curve_shape}
/// Creates a bezier curve.
/// {@endtemplate}
class BezierCurveShape extends ChainShape {
  /// {@macro bezier_curve_shape}
  BezierCurveShape({
    required this.controlPoints,
  }) {
    createChain(calculateBezierCurve(controlPoints: controlPoints));
  }

  /// Specifies the control points of the curve.
  ///
  /// First and last [controlPoints] set the beginning and end of the curve,
  /// inner points between them set its final shape.
  final List<Vector2> controlPoints;

  /// Rotates the bezier curve by a given [angle] in radians.
  void rotate(double angle) {
    vertices.map((vector) => vector..rotate(angle)).toList();
  }
}
