// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/sparky_scorch/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_scorch}
/// Area positioned at the top left of the board containing the
/// [SparkyComputer], [SparkyAnimatronic], and [SparkyBumper]s.
/// {@endtemplate}
class SparkyScorch extends Component {
  /// {@macro sparky_scorch}
  SparkyScorch()
      : super(
          children: [
            SparkyBumper.a(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-22.9, -41.65),
            SparkyBumper.b(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-21.25, -57.9),
            SparkyBumper.c(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-3.3, -52.55),
            SparkyAnimatronic(
              children: [
                AnimatronicLoopingBehavior(animationCoolDown: 3),
              ],
            )..position = Vector2(-14, -58.2),
            SparkyComputer(
              children: [
                ScoringContactBehavior(points: Points.twoHundredThousand)
                  ..applyTo(['turbo_charge_sensor']),
              ],
            ),
            SparkyComputerBonusBehavior(),
          ],
        );

  /// Creates [SparkyScorch] without any children.
  ///
  /// This can be used for testing [SparkyScorch]'s behaviors in isolation.
  @visibleForTesting
  SparkyScorch.test();
}
