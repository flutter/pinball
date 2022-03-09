import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart';

/// {@template pathway}
/// [Pathway] creates lines of various shapes.
///
/// [BodyComponent]s such as a Ball can collide and move along a [Pathway].
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

  /// Creates a uniform unidirectional (straight) [Pathway].
  ///
  /// Does so with two [ChainShape] separated by a [width]. Placed
  /// at a [position] between [start] and [end] points. Can
  /// be rotated by a given [rotation] in radians.
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.straight({
    Color? color,
    required Vector2 position,
    required Vector2 start,
    required Vector2 end,
    required double width,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];
    final wall1 = [
      start.clone(),
      end.clone(),
    ].map((vector) => vector..rotate(rotation)).toList();
    paths.add(wall1);

    if (!singleWall) {
      final wall2 = [
        start + Vector2(width, 0),
        end + Vector2(width, 0),
      ].map((vector) => vector..rotate(rotation)).toList();
      paths.add(wall2);
    }

    return Pathway._(
      color: color,
      position: position,
      paths: paths,
    );
  }

  /// Creates an arc [Pathway].
  ///
  /// The [angle], in radians, specifies the size of the arc. For example, 2*pi
  /// returns a complete circumference and minor angles a semi circumference.
  ///
  /// The center of the arc is placed at [position].
  ///
  /// Does so with two [ChainShape] separated by a [width]. Which can be
  /// rotated by a given [rotation] in radians.
  ///
  /// The outer radius is specified by [radius], whilst the inner one is
  /// equivalent to [radius] - [width].
  ///
  /// If [singleWall] is true, just one [ChainShape] is created.
  factory Pathway.arc({
    Color? color,
    required Vector2 position,
    required double width,
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
        radius: radius - width,
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
    required Vector2 position,
    required List<Vector2> controlPoints,
    required double width,
    double rotation = 0,
    bool singleWall = false,
  }) {
    final paths = <List<Vector2>>[];

    final wall1 = calculateBezierCurve(controlPoints: controlPoints)
        .map((vector) => vector..rotate(rotation))
        .toList();
    paths.add(wall1);

    if (!singleWall) {
      final wall2 = calculateBezierCurve(
        controlPoints: controlPoints
            .map((vector) => vector + Vector2(width, -width))
            .toList(),
      ).map((vector) => vector..rotate(rotation)).toList();
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
