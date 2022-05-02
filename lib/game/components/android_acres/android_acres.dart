// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template android_acres}
/// Area positioned on the left side of the board containing the
/// [AndroidSpaceship], [SpaceshipRamp], [SpaceshipRail], and [AndroidBumper]s.
/// {@endtemplate}
class AndroidAcres extends Component {
  /// {@macro android_acres}
  AndroidAcres()
      : super(
          children: [
            SpaceshipRamp(),
            SpaceshipRail(),
            AndroidSpaceship(position: Vector2(-26.5, -28.5)),
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
            RampShotBehavior(
              points: 5000,
              scorePosition: Vector2(0, -45),
            ),
            RampBonusBehavior(
              points: 1000000,
              scorePosition: Vector2(0, -60),
            ),
          ],
        );

  /// Creates a [AndroidAcres] without any children.
  ///
  /// This can be used for testing [AndroidAcres]'s behaviors in isolation.
  @visibleForTesting
  AndroidAcres.test();
}