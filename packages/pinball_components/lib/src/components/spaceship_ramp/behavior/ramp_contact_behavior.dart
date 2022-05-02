// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_contact_behavior}
/// Detects a [Ball]that enters in the [SpaceshipRamp].
///
/// The [Ball] can hit with sensor at door or sensor inside, just to recognize
/// when if [Ball] comes from out.
/// {@endtemplate}
class RampContactBehavior extends ContactBehavior<RampSensor> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is! Ball) return;
    switch (parent.type) {
      case RampSensorType.door:
        parent.bloc.onDoor(other);
        break;
      case RampSensorType.inside:
        parent.bloc.onInside(other);
        break;
    }
  }
}
