import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template drain}
/// Area located at the bottom of the board to detect when a [Ball] is lost.
/// {@endtemplate}
class Drain extends BodyComponent {
  /// {@macro drain}
  Drain() {
    renderBody = false;
  }

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
}
