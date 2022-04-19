// TODO(alestiago): Remove once the below is merged and updated.
// https://github.com/flame-engine/flame/pull/1547

// ignore_for_file: public_member_api_docs
// ignore_for_file: avoid_renaming_method_parameters
import 'package:flame_forge2d/flame_forge2d.dart';

abstract class ContactCallbacks2 {
  void beginContact(Object other, Contact contact) {}
  void endContact(Object other, Contact contact) {}
  void preSolve(Object other, Contact contact, Manifold oldManifold) {}
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {}
}

/// Listens to the entire [World] contacts events.
///
/// It propagates contact events ([beginContact], [endContact], [preSolve],
/// [postSolve]) to other [ContactCallbacks]s when a [Body] or at least one of
/// its fixtures `userData` is set to a [ContactCallbacks].
///
/// If the [Body] `userData` is set to a [ContactCallbacks] the contact events
/// of this will be called to when any [Body]'s fixture contacts another
/// [Fixture].
///
/// If instead you wish to be more specific and only trigger contact events
/// when a specific [Body]'s fixture contacts with another [Fixture] you can
/// set the fixture `userData` to a [ContactCallbacks].
///
/// The described behaviour is a simple out of the box solution to propagate
/// contact events. If you wish to implement your own logic you can subclass
/// [ContactListener] and provide it to your [Forge2DGame].
class WorldContactListener extends ContactListener {
  void _callback(
    Contact contact,
    void Function(ContactCallbacks2 contactCallback, Object other) callback,
  ) {
    final userDatas = {
      contact.bodyA.userData,
      contact.fixtureA.userData,
      contact.bodyB.userData,
      contact.fixtureB.userData,
    }.whereType<Object>();

    for (final contactCallback in userDatas.whereType<ContactCallbacks2>()) {
      for (final object in userDatas) {
        if (object != contactCallback) {
          callback(contactCallback, object);
        }
      }
    }
  }

  @override
  void beginContact(Contact contact) {
    _callback(
      contact,
      (contactCallback, other) => contactCallback.beginContact(other, contact),
    );
  }

  @override
  void endContact(Contact contact) {
    _callback(
      contact,
      (contactCallback, other) => contactCallback.endContact(other, contact),
    );
  }

  @override
  void preSolve(Contact contact, Manifold oldManifold) {
    _callback(
      contact,
      (contactCallback, other) =>
          contactCallback.preSolve(other, contact, oldManifold),
    );
  }

  @override
  void postSolve(Contact contact, ContactImpulse contactImpulse) {
    _callback(
      contact,
      (contactCallback, other) =>
          contactCallback.postSolve(other, contact, contactImpulse),
    );
  }
}
