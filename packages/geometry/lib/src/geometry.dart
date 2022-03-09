import 'dart:math' as math;
import 'package:flame/extensions.dart';

/// Calculates all [Vector2]s of a circumference.
///
/// Circumference is created from a [center] and a [radius]
/// Also semi circumference could be created, specifying its [angle] in radians
/// and the offset start angle [offsetAngle] for this semi circumference.
/// The higher the [precision], the more [Vector2]s will be calculated,
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
    final xCoord = center.x + radius * math.cos((stepAngle * i) + offsetAngle);
    final yCoord = center.y - radius * math.sin((stepAngle * i) + offsetAngle);

    final point = Vector2(xCoord, yCoord);
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
    var xCoord = 0.0;
    var yCoord = 0.0;
    for (var i = 0; i <= n; i++) {
      final point = controlPoints[i];

      xCoord +=
          binomial(n, i) * math.pow(1 - t, n - i) * math.pow(t, i) * point.x;
      yCoord +=
          binomial(n, i) * math.pow(1 - t, n - i) * math.pow(t, i) * point.y;
    }
    points.add(Vector2(xCoord, yCoord));

    t = t + step;
  } while (t <= 1);

  return points;
}

/// Calculates the binomial coefficient of 'n' and 'k'.
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
/// For more information read: https://en.wikipedia.org/wiki/Factorial
num factorial(num n) {
  assert(n >= 0, 'Factorial is not defined for negative number n ($n)');

  if (n == 0 || n == 1) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}
