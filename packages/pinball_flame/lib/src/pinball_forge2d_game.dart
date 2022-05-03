import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/world_contact_listener.dart';

// NOTE(wolfen): This should be removed when https://github.com/flame-engine/flame/pull/1597 is solved.
/// {@template pinball_forge2d_game}
/// A [Game] that uses the Forge2D physics engine.
/// {@endtemplate}
class PinballForge2DGame extends FlameGame implements Forge2DGame {
  /// {@macro pinball_forge2d_game}
  PinballForge2DGame({
    required Vector2 gravity,
  })  : world = World(gravity),
        super(camera: Camera()) {
    camera.zoom = Forge2DGame.defaultZoom;
    world.setContactListener(WorldContactListener());
  }

  @override
  final World world;

  @override
  void update(double dt) {
    super.update(dt);
    world.stepDt(min(dt, 1 / 60));
  }

  @override
  Vector2 screenToFlameWorld(Vector2 position) {
    throw UnimplementedError();
  }

  @override
  Vector2 screenToWorld(Vector2 position) {
    throw UnimplementedError();
  }

  @override
  Vector2 worldToScreen(Vector2 position) {
    throw UnimplementedError();
  }
}
