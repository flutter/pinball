// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_ball_contact_behavior}
/// Detects a [Ball]that enters in the [SpaceshipRamp].
///
/// The [Ball] can hit with sensor to recognize if [Ball] goes in or out the
/// [SpaceshipRamp].
/// {@endtemplate}
class RampBallContactBehavior extends ContactBehavior<RampScoringSensor> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    if (other.body.linearVelocity.y < 0) {
      parent.parent.bloc.onBallInside();
    }
  }
}
