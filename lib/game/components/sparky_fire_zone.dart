// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_fire_zone}
/// Area positioned at the top left of the [Board] where the [Ball]
/// can bounce off [SparkyBumper]s.
///
/// When a [Ball] hits [SparkyBumper]s, the bumper animates.
/// {@endtemplate}
class SparkyFireZone extends Component with HasGameRef<PinballGame> {
  /// {@macro sparky_fire_zone}
  SparkyFireZone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameRef.addContactCallback(SparkyBumperBallContactCallback());

    final lowerLeftBumper = _SparkyBumper.a()
      ..initialPosition = Vector2(-22.9, -41.65);
    final upperLeftBumper = _SparkyBumper.b()
      ..initialPosition = Vector2(-21.25, -57.9);
    final rightBumper = _SparkyBumper.c()
      ..initialPosition = Vector2(-3.3, -52.55);

    await addAll([
      lowerLeftBumper,
      upperLeftBumper,
      rightBumper,
    ]);
  }
}

// TODO(alestiago): Revisit ScorePoints logic once the FlameForge2D
// ContactCallback process is enhanced.
class _SparkyBumper extends SparkyBumper with ScorePoints {
  _SparkyBumper.a() : super.a();

  _SparkyBumper.b() : super.b();

  _SparkyBumper.c() : super.c();

  @override
  int get points => 20;
}

/// Listens when a [Ball] bounces bounces against a [SparkyBumper].
@visibleForTesting
class SparkyBumperBallContactCallback
    extends ContactCallback<SparkyBumper, Ball> {
  @override
  void begin(
    SparkyBumper sparkyBumper,
    Ball _,
    Contact __,
  ) {
    sparkyBumper.animate();
  }
}
