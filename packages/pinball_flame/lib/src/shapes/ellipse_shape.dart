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
  /// Where the initial painting begins.
  final Vector2 center;

  /// Major radius is specified by [majorRadius].
  final double majorRadius;

  /// Minor radius is specified by [minorRadius].
  final double minorRadius;

  /// Rotates the ellipse by a given [angle] in radians.
  void rotate(double angle) {
    for (final vector in vertices) {
      vector.rotate(angle);
    }
  }
}
