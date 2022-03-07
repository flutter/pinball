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
  Flipper({
    required Vector2 position,
    required this.side,
  })  : _position = position,
        _speed = _calculateSpeed() {
    // TODO(alestiago): Use sprite instead of color when provided.
    paint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;
  }

  /// The width of the [Flipper].
  static const width = 12.0;

  /// The height of the [Flipper].
  static const height = 2.8;

  /// The total duration of a full flipper's arc motion.
  ///
  /// A full flipper's arc motion is from the resting position to the highest
  /// position.
  static const _sweepingAnimationDuration = Duration(milliseconds: 100);

  /// The total amount of speed required to move the [Flipper] from the resting
  /// position to the highest position.
  static double _calculateSpeed() {
    // TODO(alestiago): test correctness.
    const angle = FlipperAnchorRevoluteJointDef._sweepingAngle / 2;
    final sweepingDistance = (width * math.sin(angle)) * 2;

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

  /// Whether the [Flipper] is on the left or right side of the board.
  ///
  /// A [Flipper] with [BoardSide.left] has a counter-clockwise arc motion,
  /// whereas a [Flipper] with [BoardSide.right] has a clockwise arc motion.
  final BoardSide side;

  /// Applies downard linear velocity to the [Flipper] to move it up.
  void moveDown() {
    body.linearVelocity = Vector2(0, -_speed);
  }

  /// Applies upward linear velocity to the [Flipper] to move it up.
  void moveUp() {
    body.linearVelocity = Vector2(0, _speed);
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixtures = <FixtureDef>[];
    final isRight = side.isRight;

    const bigRadius = height / 2;
    final bigCircleShape = CircleShape()
      ..radius = bigRadius
      ..position.setValues(
        isRight ? width - bigRadius : bigRadius,
        -bigRadius,
      );
    final bigCircleFixtureDef = FixtureDef(bigCircleShape);
    fixtures.add(bigCircleFixtureDef);

    const smallRadius = bigRadius / 2;
    final smallCircleShape = CircleShape()
      ..radius = smallRadius
      ..position.setValues(
        isRight ? smallRadius : width - smallRadius,
        -2 * smallRadius,
      );
    final smallCircleFixtureDef = FixtureDef(smallCircleShape);
    fixtures.add(smallCircleFixtureDef);

    const inclineSpace = (height - (2 * smallRadius)) / 2;
    final trapeziumVertices = isRight
        ? [
            Vector2(smallRadius, -inclineSpace),
            Vector2(width - bigRadius, 0),
            Vector2(width - bigRadius, -height),
            Vector2(smallRadius, -height + inclineSpace),
          ]
        : [
            Vector2(bigCircleShape.radius, 0),
            Vector2(width - smallCircleShape.radius, -inclineSpace),
            Vector2(width - smallCircleShape.radius, -height + inclineSpace),
            Vector2(bigCircleShape.radius, -height),
          ];
    final trapezium = PolygonShape()..set(trapeziumVertices);
    final trapeziumFixtureDef = FixtureDef(trapezium)
      ..density = 50.0 // TODO(alestiago): Use a proper density.
      ..friction = .1; // TODO(alestiago): Use a proper friction.
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

  // TODO(erickzanardo): Remove this once the issue is solved:
  // https://github.com/flame-engine/flame/issues/1417
  final Completer hasMounted = Completer<void>();

  @override
  void onMount() {
    super.onMount();
    hasMounted.complete();
  }
}

/// {@template flipper_anchor_revolute_joint}
/// [Anchor] positioned at the end of a [Flipper].
///
/// The end of a [Flipper] depends on its [Flipper.side].
/// {@endtemplate}
class FlipperAnchor extends Anchor {
  /// {@macro flipper_anchor_revolute_joint}
  FlipperAnchor({
    required Flipper flipper,
  }) : super(
          position: Vector2(
            flipper.side.isLeft
                ? flipper.body.position.x
                : flipper.body.position.x + Flipper.width,
            flipper.body.position.y - Flipper.height / 2,
          ),
        );
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to a [Anchor] to achieve an arc motion.
/// {@endtemplate}
class FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required Anchor anchor,
  }) {
    initialize(
      flipper.body,
      anchor.body,
      anchor.body.position,
    );
    enableLimit = true;

    final angle = flipper.side.isRight ? -_sweepingAngle : _sweepingAngle;
    lowerAngle = angle;
    upperAngle = angle;
  }

  /// The total angle of the arc motion.
  static const _sweepingAngle = math.pi / 7;
}
