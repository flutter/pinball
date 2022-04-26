import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class ContactBehavior extends Component
    with ContactCallbacks, ParentIsA<AlienBumper> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Consider defining a generic ContactBehaviour to get
    // rid of this repeated logic.
    final userData = parent.body.userData;
    if (userData is ContactCallbacksGroup) {
      userData.addContactCallbacks(this);
    } else if (userData is ContactCallbacks) {
      final notifier = ContactCallbacksGroup()
        ..addContactCallbacks(userData)
        ..addContactCallbacks(this);
      parent.body.userData = notifier;
    } else {
      parent.body.userData = this;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;
    parent.bloc.onBallContacted();
  }
}
