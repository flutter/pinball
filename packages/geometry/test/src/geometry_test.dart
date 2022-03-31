// ignore_for_file: prefer_const_constructors, cascade_invocations

import 'package:geometry/geometry.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

class Binomial {
  Binomial({required this.n, required this.k});

  final num n;
  final num k;
}

void main() {
  group('calculateArc', () {
    test('returns by default 100 points as indicated by precision', () {
      final points = calculateArc(
        center: Vector2.zero(),
        radius: 100,
        angle: 90,
      );
      expect(points.length, 100);
    });

    test('returns as many points as indicated by precision', () {
      final points = calculateArc(
        center: Vector2.zero(),
        radius: 100,
        angle: 90,
        precision: 50,
      );
      expect(points.length, 50);
    });
  });

  group('calculateEllipse', () {
    test('returns by default 100 points as indicated by precision', () {
      final points = calculateEllipse(
        center: Vector2.zero(),
        majorRadius: 100,
        minorRadius: 50,
      );
      expect(points.length, 100);
    });

    test('returns as many points as indicated by precision', () {
      final points = calculateEllipse(
        center: Vector2.zero(),
        majorRadius: 100,
        minorRadius: 50,
        precision: 50,
      );
      expect(points.length, 50);
    });

    test('fails if radius not in range', () {
      expect(
        () => calculateEllipse(
          center: Vector2.zero(),
          majorRadius: 100,
          minorRadius: 150,
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => calculateEllipse(
          center: Vector2.zero(),
          majorRadius: 100,
          minorRadius: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('calculateBezierCurve', () {
    test('fails if step not in range', () {
      expect(
        () => calculateBezierCurve(
          controlPoints: [
            Vector2(0, 0),
            Vector2(10, 10),
          ],
          step: 2,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('fails if not enough control points', () {
      expect(
        () => calculateBezierCurve(controlPoints: [Vector2.zero()]),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => calculateBezierCurve(controlPoints: []),
        throwsA(isA<AssertionError>()),
      );
    });

    test('returns by default 100 points as indicated by step', () {
      final points = calculateBezierCurve(
        controlPoints: [
          Vector2(0, 0),
          Vector2(10, 10),
        ],
      );
      expect(points.length, 100);
    });

    test('returns as many points as indicated by step', () {
      final points = calculateBezierCurve(
        controlPoints: [
          Vector2(0, 0),
          Vector2(10, 10),
        ],
        step: 0.001,
      );
      expect(points.length, 1000);
    });
  });

  group('binomial', () {
    test('fails if k is negative', () {
      expect(
        () => binomial(1, -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('fails if n is negative', () {
      expect(
        () => binomial(-1, 1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('fails if n < k', () {
      expect(
        () => binomial(1, 2),
        throwsA(isA<AssertionError>()),
      );
    });

    test('for a specific input gives a correct value', () {
      final binomialInputsToExpected = {
        Binomial(n: 0, k: 0): 1,
        Binomial(n: 1, k: 0): 1,
        Binomial(n: 1, k: 1): 1,
        Binomial(n: 2, k: 0): 1,
        Binomial(n: 2, k: 1): 2,
        Binomial(n: 2, k: 2): 1,
        Binomial(n: 3, k: 0): 1,
        Binomial(n: 3, k: 1): 3,
        Binomial(n: 3, k: 2): 3,
        Binomial(n: 3, k: 3): 1,
        Binomial(n: 4, k: 0): 1,
        Binomial(n: 4, k: 1): 4,
        Binomial(n: 4, k: 2): 6,
        Binomial(n: 4, k: 3): 4,
        Binomial(n: 4, k: 4): 1,
        Binomial(n: 5, k: 0): 1,
        Binomial(n: 5, k: 1): 5,
        Binomial(n: 5, k: 2): 10,
        Binomial(n: 5, k: 3): 10,
        Binomial(n: 5, k: 4): 5,
        Binomial(n: 5, k: 5): 1,
        Binomial(n: 6, k: 0): 1,
        Binomial(n: 6, k: 1): 6,
        Binomial(n: 6, k: 2): 15,
        Binomial(n: 6, k: 3): 20,
        Binomial(n: 6, k: 4): 15,
        Binomial(n: 6, k: 5): 6,
        Binomial(n: 6, k: 6): 1,
      };
      binomialInputsToExpected.forEach((input, value) {
        expect(binomial(input.n, input.k), value);
      });
    });
  });

  group('factorial', () {
    test('fails if negative number', () {
      expect(() => factorial(-1), throwsA(isA<AssertionError>()));
    });

    test('for a specific input gives a correct value', () {
      final factorialInputsToExpected = {
        0: 1,
        1: 1,
        2: 2,
        3: 6,
        4: 24,
        5: 120,
        6: 720,
        7: 5040,
        8: 40320,
        9: 362880,
        10: 3628800,
        11: 39916800,
        12: 479001600,
        13: 6227020800,
      };
      factorialInputsToExpected.forEach((input, expected) {
        expect(factorial(input), expected);
      });
    });
  });

  group('centroid', () {
    test('throws AssertionError when vertices are empty', () {
      expect(() => centroid([]), throwsA(isA<AssertionError>()));
    });

    test('is correct when one vertex is given', () {
      expect(centroid([Vector2.zero()]), Vector2.zero());
    });

    test('is correct when two vertex are given', () {
      expect(centroid([Vector2.zero(), Vector2(1, 1)]), Vector2(0.5, 0.5));
    });

    test('is correct when three vertex are given', () {
      expect(
        centroid([
          Vector2.zero(),
          Vector2(1, 1),
          Vector2(2, 2),
        ]),
        Vector2(1, 1),
      );
    });
  });
}
