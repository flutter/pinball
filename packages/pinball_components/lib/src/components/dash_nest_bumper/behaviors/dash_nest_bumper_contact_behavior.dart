import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class DashBumperBallContactBehavior extends ContactBehavior<DashNestBumper> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;
    parent.bloc.onBallContacted();
  }
}
