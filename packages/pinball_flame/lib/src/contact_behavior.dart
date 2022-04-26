import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_flame/pinball_flame.dart';

class ContactBehavior<T extends BodyComponent> extends Component
    with ContactCallbacks, ParentIsA<T> {
  @override
  @mustCallSuper
  Future<void> onLoad() async {
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
}

class ContactCallbacksGroup implements ContactCallbacks {
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
