import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class AndroidBumperBallContactBehavior extends ContactBehavior<AndroidBumper> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;
    parent.bloc.onBallContacted();
  }
}
