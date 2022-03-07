import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:maths/maths.dart';

/// {@template path}
/// [Path] creates different shapes that sets the pathways that ball can follow
/// or collide to like walls.
/// {@endtemplate}
class Path extends BodyComponent {
  Path._({
    Color? color,
    required Vector2 position,
    required List<List<Vector2>> paths,
  })  : _position = position,
        _paths = paths {
    paint = Paint()
      ..color = color ?? const Color.fromARGB(0, 0, 0, 0)
      ..style = PaintingStyle.stroke;
  }

  /// {@macro path}
  /// [Path.straight] creates a straight path for the ball given a [position]
  /// for the body, between a [start] and [end] points.
  /// It creates two [ChainShape] separated by a [pathWidth]. If [singleWall]
  /// is true, just one [ChainShape] is created (like a wall instead of a path)
  /// The path could be rotated by [rotation] in degrees.
  factory Path.straight({
    Color? color,
    required Vector2 position,
    required Vector2 start,
    required Vector2 end,
    required double pathWidth,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];
    final wall1 = [
      start.clone(),
      end.clone(),
    ];
    paths.add(wall1.map((e) => e..rotate(radians(rotation))).toList());

    if (!singleWall) {
      final wall2 = [
        start + Vector2(pathWidth, 0),
        end + Vector2(pathWidth, 0),
      ];
      paths.add(wall2.map((e) => e..rotate(radians(rotation))).toList());
    }

    return Path._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  /// {@macro path}
  /// [Path.straight] creates an arc path for the ball given a [position]
  /// for the body, a [radius] for the circumference and an [angle] to specify
  /// the size of the semi circumference.
  /// It creates two [ChainShape] separated by a [pathWidth], like a circular
  /// crown. The specified [radius] is for the outer arc, the inner one will
  /// have a radius of radius-pathWidth.
  /// If [singleWall] is true, just one [ChainShape] is created.
  /// The path could be rotated by [rotation] in degrees.
  factory Path.arc({
    Color? color,
    required Vector2 position,
    required double pathWidth,
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
      final minRadius = radius - pathWidth;

      final wall2 = calculateArc(
        center: position,
        radius: minRadius,
        angle: angle,
        offsetAngle: rotation,
      );
      paths.add(wall2);
    }

    return Path._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  /// {@macro path}
  /// [Path.straight] creates a bezier curve path for the ball given a
  /// [position] for the body, with control point specified by [controlPoints].
  /// First and last points set the beginning and end of the curve, all the
  /// inner points between them set the bezier curve final shape.
  /// It creates two [ChainShape] separated by a [pathWidth]. If [singleWall]
  /// is true, just one [ChainShape] is created (like a wall instead of a path)
  /// The path could be rotated by [rotation] in degrees.
  factory Path.bezierCurve({
    Color? color,
    required Vector2 position,
    required List<Vector2> controlPoints,
    required double pathWidth,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateBezierCurve(controlPoints: controlPoints);
    paths.add(wall1.map((e) => e..rotate(radians(rotation))).toList());

    var wall2 = <Vector2>[];
    if (!singleWall) {
      wall2 = calculateBezierCurve(
        controlPoints: controlPoints
            .map((e) => e + Vector2(pathWidth, -pathWidth))
            .toList(),
      );
      paths.add(wall2.map((e) => e..rotate(radians(rotation))).toList());
    }

    return Path._(
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
