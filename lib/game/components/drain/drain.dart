import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:pinball/game/components/drain/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template drain}
/// Area located at the bottom of the board.
///
/// Its [DrainingBehavior] handles removing a [Ball] from the game.
/// {@endtemplate}
class Drain extends BodyComponent with ContactCallbacks {
  /// {@macro drain}
  Drain()
      : super(
          renderBody: false,
          children: [DrainingBehavior()],
        );

  /// Creates a [Drain] without any children.
  ///
  /// This can be used for testing a [Drain]'s behaviors in isolation.
  @visibleForTesting
  Drain.test();

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        BoardDimensions.bounds.bottomLeft.toVector2(),
        BoardDimensions.bounds.bottomRight.toVector2(),
      );
    final fixtureDef = FixtureDef(shape, isSensor: true);
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}
