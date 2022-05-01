// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_scorch}
/// Area positioned at the top left of the board containing the
/// [SparkyComputer], [SparkyAnimatronic], and [SparkyBumper]s.
/// {@endtemplate}
class SparkyScorch extends Blueprint {
  /// {@macro sparky_scorch}
  SparkyScorch()
      : super(
          components: [
            SparkyBumper.a(
              children: [
                ScoringBehavior(points: Points.twentyThousand),
              ],
            )..initialPosition = Vector2(-22.9, -41.65),
            SparkyBumper.b(
              children: [
                ScoringBehavior(points: Points.twentyThousand),
              ],
            )..initialPosition = Vector2(-21.25, -57.9),
            SparkyBumper.c(
              children: [
                ScoringBehavior(points: Points.twentyThousand),
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
  SparkyComputerSensor()
      : super(
          renderBody: false,
          children: [
            ScoringBehavior(points: Points.twentyThousand),
          ],
        );

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
