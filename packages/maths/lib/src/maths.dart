import 'dart:math' as math;
import 'package:flame/extensions.dart';

/// Method to calculate all points (with a required precision amount of them)
/// of a circumference based on angle, offsetAngle and radius
/// https://en.wikipedia.org/wiki/Trigonometric_functions
List<Vector2> calculateArc({
  required Vector2 center,
  required double radius,
  required double angle,
  double offsetAngle = 0,
  int precision = 100,
}) {
  final stepAngle = radians(angle / (precision - 1));
  final stepOffset = radians(offsetAngle);

  final points = <Vector2>[];
  for (var i = 0; i < precision; i++) {
    final xCoord = center.x + radius * math.cos((stepAngle * i) + stepOffset);
    final yCoord = center.y - radius * math.sin((stepAngle * i) + stepOffset);

    final point = Vector2(xCoord, yCoord);
    points.add(point);
  }

  return points;
}

/// Method that calculates all points of a bezier curve of degree 'g' and
/// n=g-1 control points and range 0<=t<=1
/// https://en.wikipedia.org/wiki/B%C3%A9zier_curve
List<Vector2> calculateBezierCurve({
  required List<Vector2> controlPoints,
  double step = 0.001,
}) {
  assert(0 <= step && step <= 1, 'Range 0<=step<=1');
  assert(
    controlPoints.length >= 2,
    'At least 2 control points to create a bezier curve',
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

/// Method to calculate the binomial coefficient of 'n' and 'k'
/// https://en.wikipedia.org/wiki/Binomial_coefficient
num binomial(num n, num k) {
  assert(0 <= k && k <= n, 'Range 0<=k<=n');
  if (k == 0 || n == k) {
    return 1;
  } else {
    return factorial(n) / (factorial(k) * factorial(n - k));
  }
}

/// Method to calculate the factorial of some number 'n'
/// https://en.wikipedia.org/wiki/Factorial
num factorial(num n) {
  assert(0 <= n, 'Non negative n');
  if (n == 0) {
    return 1;
  } else if (n == 1) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}
