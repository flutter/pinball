// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_ball_ascending_contact_behavior}
/// Detects an ascending [Ball] that enters into the [SpaceshipRamp].
///
/// The [Ball] can hit with sensor to recognize if a [Ball] goes into or out of
/// the [SpaceshipRamp].
/// {@endtemplate}
class RampBallAscendingContactBehavior
    extends ContactBehavior<RampScoringSensor> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    if (other.body.linearVelocity.y < 0) {
      parent.parent.bloc.onAscendingBallEntered();
    }
  }
}
