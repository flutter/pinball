import 'dart:math' as math;

import 'package:flame/extensions.dart';

/// {@template board_dimensions}
/// Contains various board properties and dimensions for global use.
/// {@endtemplate}
// TODO(allisonryan0002): consider alternatives for global dimensions.
class BoardDimensions {
  /// Width and height of the board.
  static final size = Vector2(101.6, 143.8);

  /// [Rect] for easier access to board boundaries.
  static final bounds = Rect.fromCenter(
    center: Offset.zero,
    width: size.x,
    height: size.y,
  );

  /// 3D perspective angle of the board in radians.
  static final perspectiveAngle = -math.atan(18.6 / bounds.height);

  /// Factor the board shrinks by from the closest point to the farthest.
  static const perspectiveShrinkFactor = 0.63;

  /// Board height based on the [perspectiveShrinkFactor].
  static final shrinkAdjustedHeight =
      (1 / (1 - perspectiveShrinkFactor)) * size.y;
}
