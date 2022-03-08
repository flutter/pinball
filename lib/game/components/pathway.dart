import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart';

/// {@template pathway}
/// [Pathway] creates lines of various shapes that the ball can collide
/// with and move along.
/// {@endtemplate}
class Pathway extends BodyComponent {
  Pathway._({
    // TODO(ruialonso): remove color when assets added.
    Color? color,
    required Vector2 position,
    required List<List<Vector2>> paths,
  })  : _position = position,
        _paths = paths {
    paint = Paint()
      ..color = color ?? const Color.fromARGB(0, 0, 0, 0)
      ..style = PaintingStyle.stroke;
  }

  /// {@macro pathway}
  /// [Pathway.straight] creates a straight pathway for the ball.
  ///
  /// given a [position] for the body, between a [start] and [end] points.
  /// It creates two [ChainShape] separated by a [pathwayWidth].
  /// If [singleWall] is true, just one [ChainShape] is created
  /// (like a wall instead of a pathway)
  /// The pathway could be rotated by [rotation] in degrees.
  factory Pathway.straight({
    Color? color,
    required Vector2 position,
    required Vector2 start,
    required Vector2 end,
    required double pathwayWidth,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];
    final wall1 = [
      start.clone(),
      end.clone(),
    ].map((vector) => vector..rotate(radians(rotation))).toList();
    paths.add(wall1);

    if (!singleWall) {
      final wall2 = [
        start + Vector2(pathwayWidth, 0),
        end + Vector2(pathwayWidth, 0),
      ].map((vector) => vector..rotate(radians(rotation))).toList();
      paths.add(wall2);
    }

    return Pathway._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  /// {@macro pathway}
  /// [Pathway.arc] creates an arc pathway for the ball.
  ///
  /// The arc is created given a [position] for the body, a [radius] for the
  /// circumference and an [angle] to specify the size of it (360 will return
  /// a completed circumference and minor angles a semi circumference ).
  /// It creates two [ChainShape] separated by a [pathwayWidth], like a circular
  /// crown. The specified [radius] is for the outer arc, the inner one will
  /// have a radius of radius-pathwayWidth.
  /// If [singleWall] is true, just one [ChainShape] is created.
  /// The pathway could be rotated by [rotation] in degrees.
  factory Pathway.arc({
    Color? color,
    required Vector2 position,
    required double pathwayWidth,
    required double radius,
    required double angle,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateArc(
      center: position,
      radius: radius,
      angle: angle,
      offsetAngle: rotation,
    );
    paths.add(wall1);

    if (!singleWall) {
      final wall2 = calculateArc(
        center: position,
        radius: radius - pathwayWidth,
        angle: angle,
        offsetAngle: rotation,
      );
      paths.add(wall2);
    }

    return Pathway._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  /// {@macro pathway}
  /// [Pathway.bezierCurve] creates a bezier curve pathway for the ball.
  ///
  /// The curve is created given a [position] for the body, and
  /// with a list of control points specified by [controlPoints].
  /// First and last points set the beginning and end of the curve, all the
  /// inner points between them set the bezier curve final shape.
  /// It creates two [ChainShape] separated by a [pathwayWidth].
  /// If [singleWall] is true, just one [ChainShape] is created
  /// (like a wall instead of a pathway)
  /// The pathway could be rotated by [rotation] in degrees.
  factory Pathway.bezierCurve({
    Color? color,
    required Vector2 position,
    required List<Vector2> controlPoints,
    required double pathwayWidth,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateBezierCurve(controlPoints: controlPoints)
        .map((vector) => vector..rotate(radians(rotation)))
        .toList();
    paths.add(wall1);

    if (!singleWall) {
      final wall2 = calculateBezierCurve(
        controlPoints: controlPoints
            .map((vector) => vector + Vector2(pathwayWidth, -pathwayWidth))
            .toList(),
      ).map((vector) => vector..rotate(radians(rotation))).toList();
      paths.add(wall2);
    }

    return Pathway._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  final Vector2 _position;
  final List<List<Vector2>> _paths;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = _position;

    final body = world.createBody(bodyDef);

    for (final path in _paths) {
      final chain = ChainShape()
        ..createChain(
          path.map(gameRef.screenToWorld).toList(),
        );
      final fixtureDef = FixtureDef(chain);
      body.createFixture(fixtureDef);
    }

    return body;
  }
}
