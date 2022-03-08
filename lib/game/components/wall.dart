// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';

/// {@template wall}
/// A continuos generic and [BodyType.static] barrier that divides a game area.
/// {@endtemplate}
class Wall extends BodyComponent {
  Wall({
    required this.start,
    required this.end,
  });

  final Vector2 start;
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template bottom_wall}
/// [Wall] located at the bottom of the board.
///
/// Collisions with [BottomWall] are listened by
/// [BottomWallBallContactCallback].
/// {@endtemplate}
class BottomWall extends Wall {
  BottomWall(Forge2DGame game)
      : super(
          start: game.screenToWorld(game.camera.viewport.effectiveSize),
          end: Vector2(
            0,
            game.screenToWorld(game.camera.viewport.effectiveSize).y,
          ),
        );
}

/// {@template bottom_wall_ball_contact_callback}
/// Listens when a [Ball] falls into a [BottomWall].
/// {@endtemplate}
class BottomWallBallContactCallback extends ContactCallback<Ball, BottomWall> {
  @override
  void begin(Ball ball, BottomWall wall, Contact contact) {
    ball.lost();
  }

  @override
  void end(_, __, ___) {}
}
