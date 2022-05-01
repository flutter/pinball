// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the board where the [Ball] can bounce
/// off [DashNestBumper]s.
/// {@endtemplate}
class FlutterForest extends Component with ZIndex {
  /// {@macro flutter_forest}
  FlutterForest()
      : super(
          children: [
            Signpost(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(8.35, -58.3),
            DashNestBumper.main(
              children: [
                ScoringBehavior(points: 200000),
              ],
            )..initialPosition = Vector2(18.55, -59.35),
            DashNestBumper.a(
              children: [
                ScoringBehavior(points: 20000),
              ],
            )..initialPosition = Vector2(8.95, -51.95),
            DashNestBumper.b(
              children: [
                ScoringBehavior(points: 20000),
              ],
            )..initialPosition = Vector2(23.3, -46.75),
            DashAnimatronic()..position = Vector2(20, -66),
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
