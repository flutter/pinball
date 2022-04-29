import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template drain}
/// Area located at the bottom of the board to detect when a [Ball] is lost.
/// {@endtemplate}
// TODO(allisonryan0002): move to components package when possible.
class Drain extends BodyComponent with ContactCallbacks {
  /// {@macro drain}
  Drain() : super(renderBody: false);

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        BoardDimensions.bounds.bottomLeft.toVector2(),
        BoardDimensions.bounds.bottomRight.toVector2(),
      );
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(userData: this);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

// TODO(allisonryan0002): move this to ball.dart when BallLost is removed.
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! ControlledBall) return;
    other.controller.lost();
  }
}
