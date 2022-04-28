// ignore_for_file: public_member_api_docs

import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:pinball/game/components/multipliers/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template multipliers_component}
/// A group for the multipliers over the board.
/// {@endtemplate}
class Multipliers extends Component {
  /// {@macro multipliers_component}
  Multipliers()
      : super(
          children: [
            Multiplier(
              value: MultiplierValue.x2,
              position: Vector2(-19.5, -2),
              rotation: -15 * math.pi / 180,
            ),
            Multiplier(
              value: MultiplierValue.x3,
              position: Vector2(13, -9.4),
              rotation: 15 * math.pi / 180,
            ),
            Multiplier(
              value: MultiplierValue.x4,
              position: Vector2(0, -21.2),
            ),
            Multiplier(
              value: MultiplierValue.x5,
              position: Vector2(-8.5, -28),
              rotation: -3 * math.pi / 180,
            ),
            Multiplier(
              value: MultiplierValue.x6,
              position: Vector2(10, -30.7),
              rotation: 8 * math.pi / 180,
            ),
            MultipliersBehavior(),
          ],
        );
}
