import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class AlienBumperContactBehavior extends Component
    with ContactCallbacks, ParentIsA<AlienBumper> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final userData = parent.body.userData;
    if (userData is ContactCallbacksNotifer) {
      userData.addCallback(this);
    } else {
      parent.body.userData = this;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;
    parent.state = AlienBumperState.inactive;
  }
}
