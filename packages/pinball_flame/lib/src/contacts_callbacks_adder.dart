import 'package:flame_forge2d/flame_forge2d.dart';

/// {@template contact_callbacks_adder}
///
/// {@endtemplate}
// TODO(alestiago): Consider adding streams to [ContactCallbacks].
extension ContactCallbacksAdder on ContactCallbacks {
  /// {@macro contact_callbacks_adder}
  void add(ContactCallbacks contactCallbacks) {
    if (contactCallbacks.onBeginContact != null) {
      onBeginContact = (other, contact) {
        onBeginContact?.call(other, contact);
        contactCallbacks.beginContact(other, contact);
      };
    }

    if (contactCallbacks.onEndContact != null) {
      onEndContact = (other, contact) {
        onEndContact?.call(other, contact);
        contactCallbacks.endContact(other, contact);
      };
    }

    if (contactCallbacks.onPreSolve != null) {
      onPreSolve = (other, contact, oldManifold) {
        onPreSolve?.call(other, contact, oldManifold);
        contactCallbacks.preSolve(other, contact, oldManifold);
      };
    }

    if (contactCallbacks.onPostSolve != null) {
      onPostSolve = (other, contact, impulse) {
        onPostSolve?.call(other, contact, impulse);
        contactCallbacks.postSolve(other, contact, impulse);
      };
    }
  }
}
