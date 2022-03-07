import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:maths/maths.dart';

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

  factory Path.straight({
    Color? color,
    required Vector2 position,
    required Vector2 start,
    required Vector2 end,
    required double pathWidth,
    double rotation = 0,
    bool onlyOneWall = false,
  }) {
    final paths = <List<Vector2>>[];
    final wall1 = [
      start.clone(),
      end.clone(),
    ];
    paths.add(wall1.map((e) => e..rotate(radians(rotation))).toList());

    if (!onlyOneWall) {
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

  factory Path.arc({
    Color? color,
    required Vector2 position,
    required double pathWidth,
    required double radius,
    required double angle,
    double rotation = 0,
    bool onlyOneWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateArc(
      center: position,
      radius: radius,
      angle: angle,
      offsetAngle: rotation,
    );
    paths.add(wall1);

    if (!onlyOneWall) {
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

  factory Path.bezierCurve({
    Color? color,
    required Vector2 position,
    required List<Vector2> controlPoints,
    required double pathWidth,
    double rotation = 0,
    bool onlyOneWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateBezierCurve(controlPoints: controlPoints);
    paths.add(wall1.map((e) => e..rotate(radians(rotation))).toList());

    var wall2 = <Vector2>[];
    if (!onlyOneWall) {
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
          path.map((e) => gameRef.screenToWorld(e)).toList(),
        );
      final fixtureDef = FixtureDef(chain);
      body.createFixture(fixtureDef);
    }

    return body;
  }
}
