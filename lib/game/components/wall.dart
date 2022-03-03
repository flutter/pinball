// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';

class BallWallContactCallback extends ContactCallback<Ball, Wall> {
  @override
  void begin(Ball ball, Wall wall, Contact contact) {
    if (wall.type == WallType.bottom) {
      ball
        ..ballLost()
        ..shouldRemove = true;
    }
  }

  @override
  void end(_, __, ___) {}
}

enum WallType {
  top,
  bottom,
  left,
  right,
}

class Wall extends BodyComponent {
  Wall({
    required this.type,
    required this.start,
    required this.end,
  });

  factory Wall.bottom(Forge2DGame game) {
    final bottomRight = game.screenToWorld(game.camera.viewport.effectiveSize);
    final bottomLeft = Vector2(0, bottomRight.y);

    return Wall(
      type: WallType.bottom,
      start: bottomRight,
      end: bottomLeft,
    );
  }

  final Vector2 start;
  final Vector2 end;
  final WallType type;

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
