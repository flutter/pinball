import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Appends a new [ContactCallbacks] to the parent.
///
/// This is a convenience class for adding a [ContactCallbacks] to the parent.
/// In constract with just adding a [ContactCallbacks] to the parent's body
/// userData, this class respects the previous [ContactCallbacks] in the
/// parent's body userData, if any. Hence, it avoids overriding any previous
/// [ContactCallbacks] in the parent.
///
/// It does so by grouping the [ContactCallbacks] in a [_ContactCallbacksGroup],
/// and resetting the parent's userData accordingly.
// TODO(alestiago): Make use of generics to infer the type of the contact.
// https://github.com/VGVentures/pinball/pull/234#discussion_r859182267
// TODO(alestiago): Consider if there is a need to support adjusting a fixture's
// userData.
class ContactBehavior<T extends BodyComponent> extends Component
    with ContactCallbacks, ParentIsA<T> {
  @override
  @mustCallSuper
  Future<void> onLoad() async {
    final userData = parent.body.userData;
    if (userData is _ContactCallbacksGroup) {
      userData.addContactCallbacks(this);
    } else if (userData is ContactCallbacks) {
      final contactCallbacksGroup = _ContactCallbacksGroup()
        ..addContactCallbacks(userData)
        ..addContactCallbacks(this);
      parent.body.userData = contactCallbacksGroup;
    } else {
      parent.body.userData = this;
    }
  }
}

class _ContactCallbacksGroup implements ContactCallbacks {
  final List<ContactCallbacks> _contactCallbacks = [];

  @override
  @mustCallSuper
  void beginContact(Object other, Contact contact) {
    onBeginContact?.call(other, contact);
    for (final callback in _contactCallbacks) {
      callback.beginContact(other, contact);
    }
  }

  @override
  @mustCallSuper
  void endContact(Object other, Contact contact) {
    onEndContact?.call(other, contact);
    for (final callback in _contactCallbacks) {
      callback.endContact(other, contact);
    }
  }

  @override
  @mustCallSuper
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    onPreSolve?.call(other, contact, oldManifold);
    for (final callback in _contactCallbacks) {
      callback.preSolve(other, contact, oldManifold);
    }
  }

  @override
  @mustCallSuper
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    onPostSolve?.call(other, contact, impulse);
    for (final callback in _contactCallbacks) {
      callback.postSolve(other, contact, impulse);
    }
  }

  void addContactCallbacks(ContactCallbacks callback) {
    _contactCallbacks.add(callback);
  }

  @override
  void Function(Object other, Contact contact)? onBeginContact;

  @override
  void Function(Object other, Contact contact)? onEndContact;

  @override
  void Function(Object other, Contact contact, ContactImpulse impulse)?
      onPostSolve;

  @override
  void Function(Object other, Contact contact, Manifold oldManifold)?
      onPreSolve;
}
