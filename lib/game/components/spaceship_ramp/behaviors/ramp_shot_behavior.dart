// ignore_for_file: public_member_api_docs

import 'dart:collection';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class RampShotBehavior extends ContactBehavior<AndroidRampSensor> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is! Ball) return;
    switch (parent.type) {
      case AndroidRampSensorType.door:
        parent.bloc.onDoor(other);
        break;
      case AndroidRampSensorType.inside:
        parent.bloc.onInside(other);
        break;
    }
  }
}
