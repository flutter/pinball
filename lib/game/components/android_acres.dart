// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template android_acres}
/// Area positioned on the left side of the board containing the
/// [AndroidSpaceship], [SpaceshipRamp], [SpaceshipRail], and [AndroidBumper]s.
/// {@endtemplate}
class AndroidAcres extends Blueprint {
  /// {@macro android_acres}
  AndroidAcres()
      : super(
          components: [
            AndroidBumper.a(
              children: [
                ScoringBehavior(points: 20000),
              ],
            )..initialPosition = Vector2(-25, 1.3),
            AndroidBumper.b(
              children: [
                ScoringBehavior(points: 20000),
              ],
            )..initialPosition = Vector2(-32.8, -9.2),
            AndroidBumper.cow(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-20.5, -13.8),
          ],
          blueprints: [
            SpaceshipRamp(),
            AndroidSpaceship(position: Vector2(-26.5, -28.5)),
            SpaceshipRail(),
          ],
        );
}
