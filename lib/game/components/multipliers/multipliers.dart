import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/multipliers/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multipliers}
/// A group for the multipliers on the board.
/// {@endtemplate}
class Multipliers extends Component with ZIndex {
  /// {@macro multipliers}
  Multipliers()
      : super(
          children: [
            Multiplier.x2(
              position: Vector2(-19.6, -2),
              angle: -15 * math.pi / 180,
            ),
            Multiplier.x3(
              position: Vector2(12.8, -9.4),
              angle: 15 * math.pi / 180,
            ),
            Multiplier.x4(
              position: Vector2(-0.3, -21.2),
              angle: 3 * math.pi / 180,
            ),
            Multiplier.x5(
              position: Vector2(-8.9, -28),
              angle: -3 * math.pi / 180,
            ),
            Multiplier.x6(
              position: Vector2(9.8, -30.7),
              angle: 8 * math.pi / 180,
            ),
            MultipliersBehavior(),
          ],
        ) {
    zIndex = ZIndexes.decal;
  }

  /// Creates [Multipliers] without any children.
  ///
  /// This can be used for testing [Multipliers]'s behaviors in isolation.
  @visibleForTesting
  Multipliers.test();
}
