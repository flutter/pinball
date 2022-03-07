import 'dart:async';
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// {@template flipper}
/// A bat, typically found in pairs at the bottom of the board.
///
/// [Flipper] can be controlled by the player in an arc motion.
/// {@endtemplate flipper}
class Flipper extends BodyComponent {
  /// {@macro flipper}
  Flipper._({
    required Vector2 position,
    bool isMirrored = false,
  })  : _position = position,
        _isMirrored = isMirrored,
        _speed = _calculateRequiredSpeed() {
    // TODO(alestiago): Use sprite instead of color when provided.
    paint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;
  }

  /// {@macro flipper}
  Flipper.right({
    required Vector2 position,
  }) : this._(
          position: position,
          isMirrored: true,
        );

  /// {@macro flipper}
  Flipper.left({
    required Vector2 position,
  }) : this._(
          position: position,
          isMirrored: false,
        );

  static final size = Vector2(12, 2.8);

  /// The total duration of a full flipper's arc motion.
  ///
  /// A full flipper's arc motion is from the lowest position (resting point) to
  /// the highest position.
  static const _sweepingAnimationDuration = Duration(milliseconds: 100);

  static double _calculateRequiredSpeed() {
    // TODO(alestiago): test correctness.
    const angle = FlipperAnchorRevoluteJointDef._sweepingAngle / 2;
    final sweepingDistance = (size.x * math.sin(angle)) * 2;
    final seconds = _sweepingAnimationDuration.inMicroseconds /
        Duration.microsecondsPerSecond;
    return sweepingDistance / seconds;
  }

  /// The speed required to move the [Flipper] to its heighst position, while
  /// respecting the [_sweepingAnimationDuration].
  ///
  /// The speed value is proportional to the time it takes to move the flipper
  /// to its highest position.
  final double _speed;

  /// The initial position of the [Flipper] body.
  final Vector2 _position;

  /// Whether the [Flipper] is mirrored.
  ///
  /// A mirrored [Flipper] is one positioned at the right of the borad.
  final bool _isMirrored;

  /// Applies downard linear velocity to the [Flipper] to move it up.
  void moveDown() {
    body.linearVelocity = Vector2(0, -_speed);
  }

  /// Applies upward linear velocity to the [Flipper] to move it up.
  void moveUp() {
    body.linearVelocity = Vector2(0, _speed);
  }

  // TODO(erickzanardo): Remove this once the issue is solved:
  // https://github.com/flame-engine/flame/issues/1417
  final Completer hasMounted = Completer<void>();

  List<FixtureDef> _createFixtureDefs() {
    final fixtures = <FixtureDef>[];

    final bigRadius = size.y / 2;
    final bigCircleShape = CircleShape()
      ..radius = bigRadius
      ..position.setValues(
        _isMirrored ? size.x - bigRadius : bigRadius,
        -bigRadius,
      );
    final bigCircleFixtureDef = FixtureDef(bigCircleShape);
    fixtures.add(bigCircleFixtureDef);

    final smallRadius = bigRadius / 2;
    final smallCircleShape = CircleShape()
      ..radius = smallRadius
      ..position.setValues(
        _isMirrored ? smallRadius : size.x - smallRadius,
        -2 * smallRadius,
      );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);
    fixtures.add(smallCircleFixtureDef);

    final inclineSpace = (size.y - (2 * smallRadius)) / 2;
    final trapeziumVertices = _isMirrored
        ? [
            Vector2(smallRadius, -inclineSpace),
            Vector2(size.x - bigRadius, 0),
            Vector2(size.x - bigRadius, -size.y),
            Vector2(smallRadius, -size.y + inclineSpace),
          ]
        : [
            Vector2(bigCircleShape.radius, 0),
            Vector2(size.x - smallCircleShape.radius, -inclineSpace),
            Vector2(size.x - smallCircleShape.radius, -size.y + inclineSpace),
            Vector2(bigCircleShape.radius, -size.y),
          ];
    final trapezium = PolygonShape()..set(trapeziumVertices);
    final trapeziumFixtureDef = FixtureDef(trapezium)
      ..density = 50.0
      ..friction = .1;
    fixtures.add(trapeziumFixtureDef);

    return fixtures;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..gravityScale = 0
      ..type = BodyType.dynamic
      ..position = _position;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  void onMount() {
    super.onMount();
    hasMounted.complete();
  }
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to an [Anchor] to achieve an arc motion.
/// {@endtemplate}
class FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required Anchor anchor,
    bool isMirrored = false,
  }) {
    initialize(
      flipper.body,
      anchor.body,
      anchor.body.position,
    );
    enableLimit = true;
    final angle = isMirrored ? -_sweepingAngle : _sweepingAngle;
    lowerAngle = angle;
    upperAngle = angle;
  }

  /// The total angle of the arc motion.
  static const _sweepingAngle = math.pi / 7;
}
