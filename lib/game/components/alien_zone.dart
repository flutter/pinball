// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template alien_zone}
/// Area positioned below [Spaceship] where the [Ball]
/// can bounce off [AlienBumper]s.
/// {@endtemplate}
class AlienZone extends Blueprint {
  /// {@macro alien_zone}
  AlienZone()
      : super(
          components: [
            AlienBumper.a(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-32.52, -9.1),
            AlienBumper.b(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-22.89, -17.35),
          ],
        );
}
