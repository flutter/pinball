// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template wall}
/// A continuous generic and [BodyType.static] barrier that divides a game area.
/// {@endtemplate}
// TODO(alestiago): Remove [Wall] for [Pathway.straight].
class Wall extends BodyComponent {
  /// {@macro wall}
  Wall({
    required this.start,
    required this.end,
  });

  /// The [start] of the [Wall].
  final Vector2 start;

  /// The [end] of the [Wall].
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.1
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// Create top, left, and right [Wall]s for the game board.
List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft =
      PinballGame.boardBounds.topLeft.toVector2() + Vector2(18.6, 0);
  final bottomRight = PinballGame.boardBounds.bottomRight.toVector2();

  final topRight =
      PinballGame.boardBounds.topRight.toVector2() - Vector2(18.6, 0);
  final bottomLeft = PinballGame.boardBounds.bottomLeft.toVector2();

  return [
    Wall(start: topLeft, end: topRight),
    Wall(start: topRight, end: bottomRight),
    Wall(start: topLeft, end: bottomLeft),
  ];
}

/// {@template bottom_wall}
/// [Wall] located at the bottom of the board.
///
/// Collisions with [BottomWall] are listened by
/// [BottomWallBallContactCallback].
/// {@endtemplate}
class BottomWall extends Wall {
  /// {@macro bottom_wall}
  BottomWall()
      : super(
          start: PinballGame.boardBounds.bottomLeft.toVector2(),
          end: PinballGame.boardBounds.bottomRight.toVector2(),
        );
}

/// {@template bottom_wall_ball_contact_callback}
/// Listens when a [Ball] falls into a [BottomWall].
/// {@endtemplate}
class BottomWallBallContactCallback extends ContactCallback<Ball, BottomWall> {
  @override
  void begin(Ball ball, BottomWall wall, Contact contact) {
    ball.shouldRemove = true;

    // TODO(alestiago): replace with .firstChild when available.
    late final BallController? controller;
    final children = ball.children.whereType<BallController>();
    controller = children.isEmpty ? null : children.first;

    if (controller != null) controller.lost();
  }
}
