import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart';
import 'package:pinball/game/game.dart';

/// {@template pathway}
/// [Pathway] creates lines of various shapes.
///
/// [BodyComponent]s such as a Ball can collide and move along a [Pathway].
/// {@endtemplate}
class Pathway extends BodyComponent with InitialPosition, Layered {
  Pathway._({
    // TODO(ruialonso): remove color when assets added.
    Color? color,
    required List<List<Vector2>> paths,
  }) : _paths = paths {
    paint = Paint()
      ..color = color ?? const Color.fromARGB(0, 0, 0, 0)
      ..style = PaintingStyle.stroke;
  }

  /// Creates a uniform unidirectional (straight) [Pathway].
  ///
  /// Does so with two [ChainShape] separated by a [width]. Can
  /// be rotated by a given [rotation] in radians.
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.straight({
    Color? color,
    required Vector2 start,
    required Vector2 end,
    required double width,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    // TODO(ruialonso): Refactor repetitive logic
    final firstWall = [
      start.clone(),
      end.clone(),
    ].map((vector) => vector..rotate(rotation)).toList();
    paths.add(firstWall);

    if (!singleWall) {
      final secondWall = [
        start + Vector2(width, 0),
        end + Vector2(width, 0),
      ].map((vector) => vector..rotate(rotation)).toList();
      paths.add(secondWall);
    }

    return Pathway._(
      color: color,
      paths: paths,
    );
  }

  /// Creates an arc [Pathway].
  ///
  /// The [angle], in radians, specifies the size of the arc. For example, two
  /// pi returns a complete circumference.
  ///
  /// Does so with two [ChainShape] separated by a [width]. Which can be
  /// rotated by a given [rotation] in radians.
  ///
  /// The outer radius is specified by [radius], whilst the inner one is
  /// equivalent to the [radius] minus the [width].
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.arc({
    Color? color,
    required Vector2 center,
    required double width,
    required double radius,
    required double angle,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    // TODO(ruialonso): Refactor repetitive logic
    final outerWall = calculateArc(
      center: center,
      radius: radius,
      angle: angle,
      offsetAngle: rotation,
    );
    paths.add(outerWall);

    if (!singleWall) {
      final innerWall = calculateArc(
        center: center,
        radius: radius - width,
        angle: angle,
        offsetAngle: rotation,
      );
      paths.add(innerWall);
    }

    return Pathway._(
      color: color,
      paths: paths,
    );
  }

  /// Creates a bezier curve [Pathway].
  ///
  /// Does so with two [ChainShape] separated by a [width]. Which can be
  /// rotated by a given [rotation] in radians.
  ///
  /// First and last [controlPoints] set the beginning and end of the curve,
  /// inner points between them set its final shape.
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.bezierCurve({
    Color? color,
    required List<Vector2> controlPoints,
    required double width,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    // TODO(ruialonso): Refactor repetitive logic
    final firstWall = calculateBezierCurve(controlPoints: controlPoints)
        .map((vector) => vector..rotate(rotation))
        .toList();
    paths.add(firstWall);

    if (!singleWall) {
      final secondWall = calculateBezierCurve(
        controlPoints: controlPoints
            .map((vector) => vector + Vector2(width, -width))
            .toList(),
      ).map((vector) => vector..rotate(rotation)).toList();
      paths.add(secondWall);
    }

    return Pathway._(
      color: color,
      paths: paths,
    );
  }

  /// Creates an ellipse [Pathway].
  ///
  /// Does so with two [ChainShape]s separated by a [width]. Can
  /// be rotated by a given [rotation] in radians.
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.ellipse({
    Color? color,
    required Vector2 center,
    required double width,
    required double majorRadius,
    required double minorRadius,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    // TODO(ruialonso): Refactor repetitive logic
    final outerWall = calculateEllipse(
      center: center,
      majorRadius: majorRadius,
      minorRadius: minorRadius,
    ).map((vector) => vector..rotate(rotation)).toList();
    paths.add(outerWall);

    if (!singleWall) {
      final innerWall = calculateEllipse(
        center: center,
        majorRadius: majorRadius - width,
        minorRadius: minorRadius - width,
      ).map((vector) => vector..rotate(rotation)).toList();
      paths.add(innerWall);
    }

    return Pathway._(
      color: color,
      paths: paths,
    );
  }

  final List<List<Vector2>> _paths;

  /// Constructs different [ChainShape]s to form the [Pathway] shape.
  List<FixtureDef> createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    for (final path in _paths) {
      final chain = ChainShape()..createChain(path);
      fixturesDef.add(FixtureDef(chain));
    }

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    final body = world.createBody(bodyDef);
    createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}
