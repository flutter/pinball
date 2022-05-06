import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_computer_sensor_ball_contact_behavior}
/// When a [Ball] enters the [SparkyComputer] it is stopped for a period of time
/// before a [BallTurboChargingBehavior] is applied to it.
/// {@endtemplate}
class SparkyComputerSensorBallContactBehavior
    extends ContactBehavior<SparkyComputer> {
  @override
  Future<void> beginContact(Object other, Contact contact) async {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    other.stop();
    parent.bloc.onBallEntered();
    await parent.add(
      TimerComponent(
        period: 1.5,
        removeOnFinish: true,
        onTick: () async {
          other.resume();
          await other.add(
            BallTurboChargingBehavior(
              impulse: Vector2(40, 110),
            ),
          );
          parent.bloc.onBallTurboCharged();
        },
      ),
    );
  }
}
