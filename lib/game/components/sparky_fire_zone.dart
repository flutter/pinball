// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_fire_zone}
/// Area positioned at the top left of the board where the [Ball]
/// can bounce off [SparkyBumper]s.
///
/// When a [Ball] hits [SparkyBumper]s, the bumper animates.
/// {@endtemplate}
class SparkyFireZone extends Blueprint {
  /// {@macro sparky_fire_zone}
  SparkyFireZone()
      : super(
          components: [
            SparkyBumper.a(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-22.9, -41.65),
            SparkyBumper.b(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-21.25, -57.9),
            SparkyBumper.c(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(-3.3, -52.55),
            SparkyComputerSensor()..initialPosition = Vector2(-13, -49.8),
            SparkyAnimatronic()..position = Vector2(-13.8, -58.2),
          ],
          blueprints: [
            SparkyComputer(),
          ],
        );
}

/// {@template sparky_computer_sensor}
/// Small sensor body used to detect when a ball has entered the
/// [SparkyComputer].
/// {@endtemplate}
class SparkyComputerSensor extends BodyComponent
    with InitialPosition, ContactCallbacks {
  /// {@macro sparky_computer_sensor}
  SparkyComputerSensor() : super(renderBody: false);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.1;
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! ControlledBall) return;

    other.controller.turboCharge();
    gameRef.firstChild<SparkyAnimatronic>()?.playing = true;
  }
}
