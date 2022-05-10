// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the board where the [Ball] can bounce
/// off [DashBumper]s.
/// {@endtemplate}
class FlutterForest extends Component with ZIndex {
  /// {@macro flutter_forest}
  FlutterForest()
      : super(
          children: [
            Signpost(
              children: [
                ScoringContactBehavior(points: Points.fiveThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(7.95, -58.35),
            DashBumper.main(
              children: [
                ScoringContactBehavior(points: Points.twoHundredThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(18.55, -59.35),
            DashBumper.a(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(8.95, -51.95),
            DashBumper.b(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(21.8, -46.75),
            DashAnimatronic(
              children: [
                AnimatronicLoopingBehavior(animationCoolDown: 11),
              ],
            )..position = Vector2(20, -66),
            FlutterForestBonusBehavior(),
          ],
        ) {
    zIndex = ZIndexes.flutterForest;
  }

  /// Creates a [FlutterForest] without any children.
  ///
  /// This can be used for testing [FlutterForest]'s behaviors in isolation.
  @visibleForTesting
  FlutterForest.test();
}
