// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_scorch}
/// Area positioned at the top left of the board containing the
/// [SparkyComputer], [SparkyAnimatronic], and [SparkyBumper]s.
/// {@endtemplate}
class SparkyScorch extends Component {
  /// {@macro sparky_scorch}
  SparkyScorch()
      : super(
          children: [
            SparkyBumper.a(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-22.9, -41.65),
            SparkyBumper.b(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-21.25, -57.9),
            SparkyBumper.c(
              children: [
                ScoringContactBehavior(points: Points.twentyThousand),
                BumperNoiseBehavior(),
              ],
            )..initialPosition = Vector2(-3.3, -52.55),
            SparkyComputerSensor()..initialPosition = Vector2(-13.2, -49.9),
            SparkyAnimatronic()..position = Vector2(-14, -58.2),
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
            ScoringContactBehavior(points: Points.twentyThousand),
          ],
        );

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        1,
        0.1,
        Vector2.zero(),
        -0.18,
      );
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
