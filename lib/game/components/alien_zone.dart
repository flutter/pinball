// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template alien_zone}
/// Area positioned below [Spaceship] where the [Ball]
/// can bounce off [AlienBumper]s.
///
/// When a [Ball] hits an [AlienBumper], the bumper animates.
/// {@endtemplate}
class AlienZone extends Component with HasGameRef<PinballGame> {
  /// {@macro alien_zone}
  AlienZone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameRef.addContactCallback(AlienBumperBallContactCallback());

    final lowerBumper = _AlienBumper.a()
      ..initialPosition = Vector2(-32.52, -9.1);
    final upperBumper = _AlienBumper.b()
      ..initialPosition = Vector2(-22.89, -17.35);

    await addAll([
      lowerBumper,
      upperBumper,
    ]);
  }
}

// TODO(alestiago): Revisit ScorePoints logic once the FlameForge2D
// ContactCallback process is enhanced.
class _AlienBumper extends AlienBumper with ScorePoints {
  _AlienBumper.a() : super.a();

  _AlienBumper.b() : super.b();

  @override
  int get points => 20;
}

/// Listens when a [Ball] bounces against an [AlienBumper].
@visibleForTesting
class AlienBumperBallContactCallback
    extends ContactCallback<AlienBumper, Ball> {
  @override
  void begin(
    AlienBumper alienBumper,
    Ball _,
    Contact __,
  ) {
    alienBumper.animate();
  }
}
