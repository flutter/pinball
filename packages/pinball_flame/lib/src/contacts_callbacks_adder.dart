import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class ContactCallbacksNotifer implements ContactCallbacks {
  final List<ContactCallbacks> _callbacks = [];

  @override
  @mustCallSuper
  void beginContact(Object other, Contact contact) {
    onBeginContact?.call(other, contact);
    for (final callback in _callbacks) {
      callback.beginContact(other, contact);
    }
  }

  @override
  @mustCallSuper
  void endContact(Object other, Contact contact) {
    onEndContact?.call(other, contact);
    for (final callback in _callbacks) {
      callback.endContact(other, contact);
    }
  }

  @override
  @mustCallSuper
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    onPreSolve?.call(other, contact, oldManifold);
    for (final callback in _callbacks) {
      callback.preSolve(other, contact, oldManifold);
    }
  }

  @override
  @mustCallSuper
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    onPostSolve?.call(other, contact, impulse);
    for (final callback in _callbacks) {
      callback.postSolve(other, contact, impulse);
    }
  }

  void addCallback(ContactCallbacks callback) {
    _callbacks.add(callback);
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
