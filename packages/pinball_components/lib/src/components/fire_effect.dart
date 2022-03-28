import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Particle;
import 'package:flutter/material.dart';

const _particleRadius = 0.25;

// TODO(erickzanardo): This component could just be a ParticleComponet,
/// unfortunately there is a Particle Component is not a PositionComponent,
/// which makes it hard to be used since we have camera transformations and on
// top of that, PositionComponent has a bug inside forge 2d games
///
/// https://github.com/flame-engine/flame/issues/1484
/// https://github.com/flame-engine/flame/issues/1484

/// {@template fire_effect}
/// A [BodyComponent] which creates a fire trail effect using the given
/// parameters
/// {@endtemplate}
class FireEffect extends BodyComponent {
  /// {@macro fire_effect}
  FireEffect({
    required this.burstPower,
    required this.position,
    required this.direction,
  });

  /// A [double] value that will define how "strong" the burst of particles
  /// will be
  final double burstPower;

  /// The position of the burst
  final Vector2 position;

  /// Which direction the burst will aim
  final Vector2 direction;
  late Particle _particle;

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = position;

    final fixtureDef = FixtureDef(CircleShape()..radius = 0)..isSensor = true;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final children = [
      ...List.generate(4, (index) {
        return CircleParticle(
          radius: _particleRadius,
          paint: Paint()..color = Colors.yellow.darken((index + 1) / 4),
        );
      }),
      ...List.generate(4, (index) {
        return CircleParticle(
          radius: _particleRadius,
          paint: Paint()..color = Colors.red.darken((index + 1) / 4),
        );
      }),
      ...List.generate(4, (index) {
        return CircleParticle(
          radius: _particleRadius,
          paint: Paint()..color = Colors.orange.darken((index + 1) / 4),
        );
      }),
    ];
    final rng = math.Random();
    final spreadTween = Tween<double>(begin: -0.2, end: 0.2);

    _particle = Particle.generate(
      count: (rng.nextDouble() * (burstPower * 10)).toInt(),
      generator: (_) {
        final spread = Vector2(
          spreadTween.transform(rng.nextDouble()),
          spreadTween.transform(rng.nextDouble()),
        );
        final finalDirection = Vector2(direction.x, -direction.y) + spread;
        final speed = finalDirection * (burstPower * 20);

        return AcceleratedParticle(
          lifespan: 5 / burstPower,
          position: Vector2.zero(),
          speed: speed,
          child: children[rng.nextInt(children.length)],
        );
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _particle.update(dt);

    if (_particle.shouldRemove) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _particle.render(canvas);
  }
}
