import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

/// Calculates all [Vector2]s of a circumference.
///
/// A circumference can be achieved by specifying a [center] and a [radius].
/// In addition, a semi-circle can be achieved by specifying its [angle] and an
/// [offsetAngle] (both in radians).
///
/// The higher the [precision], the more [Vector2]s will be calculated;
/// achieving a more rounded arc.
///
/// For more information read: https://en.wikipedia.org/wiki/Trigonometric_functions.
List<Vector2> calculateArc({
  required Vector2 center,
  required double radius,
  required double angle,
  double offsetAngle = 0,
  int precision = 100,
}) {
  final stepAngle = angle / (precision - 1);

  final points = <Vector2>[];
  for (var i = 0; i < precision; i++) {
    final x = center.x + radius * math.cos((stepAngle * i) + offsetAngle);
    final y = center.y - radius * math.sin((stepAngle * i) + offsetAngle);

    final point = Vector2(x, y);
    points.add(point);
  }

  return points;
}

/// Calculates all [Vector2]s of an ellipse.
///
/// An ellipse can be achieved by specifying a [center], a [majorRadius] and a
/// [minorRadius].
///
/// The higher the [precision], the more [Vector2]s will be calculated;
/// achieving a more rounded ellipse.
///
/// For more information read: https://en.wikipedia.org/wiki/Ellipse.
List<Vector2> calculateEllipse({
  required Vector2 center,
  required double majorRadius,
  required double minorRadius,
  int precision = 100,
}) {
  assert(
    0 < minorRadius && minorRadius <= majorRadius,
    'smallRadius ($minorRadius) and bigRadius ($majorRadius) must be in '
    'range 0 < smallRadius <= bigRadius',
  );

  final stepAngle = 2 * math.pi / (precision - 1);

  final points = <Vector2>[];
  for (var i = 0; i < precision; i++) {
    final x = center.x + minorRadius * math.cos(stepAngle * i);
    final y = center.y - majorRadius * math.sin(stepAngle * i);

    final point = Vector2(x, y);
    points.add(point);
  }

  return points;
}

/// Calculates all [Vector2]s of a bezier curve.
///
/// A bezier curve of [controlPoints] that say how to create this curve.
///
/// First and last points specify the beginning and the end respectively
/// of the curve. The inner points specify the shape of the curve and
/// its turning points.
///
/// The [step] must be between zero and one (inclusive), indicating the
/// precision to calculate the curve.
///
/// For more information read: https://en.wikipedia.org/wiki/B%C3%A9zier_curve
List<Vector2> calculateBezierCurve({
  required List<Vector2> controlPoints,
  double step = 0.001,
}) {
  assert(
    0 <= step && step <= 1,
    'Step ($step) must be in range  0 <= step <= 1',
  );
  assert(
    controlPoints.length >= 2,
    'At least 2 control points needed to create a bezier curve',
  );

  var t = 0.0;
  final n = controlPoints.length - 1;
  final points = <Vector2>[];

  do {
    var x = 0.0;
    var y = 0.0;
    for (var i = 0; i <= n; i++) {
      final point = controlPoints[i];

      x += binomial(n, i) * math.pow(1 - t, n - i) * math.pow(t, i) * point.x;
      y += binomial(n, i) * math.pow(1 - t, n - i) * math.pow(t, i) * point.y;
    }
    points.add(Vector2(x, y));

    t = t + step;
  } while (t <= 1);

  return points;
}

/// Calculates the binomial coefficient of 'n' and 'k'.
///
/// For more information read: https://en.wikipedia.org/wiki/Binomial_coefficient
num binomial(num n, num k) {
  assert(0 <= k && k <= n, 'k ($k) and n ($n) must be in range 0 <= k <= n');

  if (k == 0 || n == k) {
    return 1;
  } else {
    return factorial(n) / (factorial(k) * factorial(n - k));
  }
}

/// Calculate the factorial of 'n'.
///
/// For more information read: https://en.wikipedia.org/wiki/Factorial
num factorial(num n) {
  assert(n >= 0, 'Factorial is not defined for negative number n ($n)');

  if (n == 0 || n == 1) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}

/// Arithmetic mean position of all the [Vector2]s in a polygon.
///
/// For more information read: https://en.wikipedia.org/wiki/Centroid
Vector2 centroid(List<Vector2> vertices) {
  assert(vertices.isNotEmpty, 'Vertices must not be empty');
  final sum = vertices.reduce((a, b) => a + b);
  return sum / vertices.length.toDouble();
}
