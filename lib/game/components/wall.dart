// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';

/// {@template wall}
///
/// A generic wall component, a static component that can
/// be used to create more complex structures.
///
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
///
/// An specifc [Wall] used to create bottom boundary of the
/// game board
///
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
///
/// The [ContactCallback] responsible for indentifying when a [Ball]
/// has fall into the bottom of the board
///
/// {@endtemplate}
class BottomWallBallContactCallback extends ContactCallback<Ball, BottomWall> {
  @override
  void begin(Ball ball, BottomWall wall, Contact contact) {
    ball.lost();
  }

  @override
  void end(_, __, ___) {}
}
