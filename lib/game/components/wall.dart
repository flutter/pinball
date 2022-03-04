// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';

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

class BottomWallBallContactCallback extends ContactCallback<Ball, BottomWall> {
  @override
  void begin(Ball ball, BottomWall wall, Contact contact) {
    ball.lost();
  }

  @override
  void end(_, __, ___) {}
}
