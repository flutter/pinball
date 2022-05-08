// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
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
            FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>(
              create: AndroidSpaceshipCubit.new,
              children: [
                SpaceshipRamp(
                  children: [
                    RampShotBehavior(points: Points.fiveThousand),
                    RampBonusBehavior(points: Points.oneMillion),
                  ],
                ),
                SpaceshipRail(),
                AndroidSpaceship(position: Vector2(-26.5, -28.5)),
                AndroidAnimatronic(
                  children: [
                    ScoringContactBehavior(points: Points.twoHundredThousand),
                  ],
                )..initialPosition = Vector2(-26, -28.25),
                AndroidBumper.a(
                  children: [
                    ScoringContactBehavior(points: Points.twentyThousand),
                    BumperNoiseBehavior(),
                  ],
                )..initialPosition = Vector2(-25.2, 1.5),
                AndroidBumper.b(
                  children: [
                    ScoringContactBehavior(points: Points.twentyThousand),
                    BumperNoiseBehavior(),
                  ],
                )..initialPosition = Vector2(-32.9, -9.3),
                AndroidBumper.cow(
                  children: [
                    ScoringContactBehavior(points: Points.twentyThousand),
                    CowBumperNoiseBehavior(),
                  ],
                )..initialPosition = Vector2(-20.7, -13),
                AndroidSpaceshipBonusBehavior(),
              ],
            ),
          ],
        );

  /// Creates [AndroidAcres] without any children.
  ///
  /// This can be used for testing [AndroidAcres]'s behaviors in isolation.
  @visibleForTesting
  AndroidAcres.test();
}
