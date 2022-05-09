import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template bumping_behavior}
/// Makes any [BodyComponent] that contacts with [parent] bounce off.
/// {@endtemplate}
class BumpingBehavior extends ContactBehavior {
  /// {@macro bumping_behavior}
  BumpingBehavior({required double strength})
      : assert(strength >= 0, "Strength can't be negative."),
        _strength = strength;

  /// Determines how strong the bump is.
  final double _strength;

  /// This is used to recognize the current state of a contact manifold in world
  /// coordinates.
  @visibleForTesting
  final WorldManifold worldManifold = WorldManifold();

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);
    if (other is! BodyComponent) return;

    contact.getWorldManifold(worldManifold);
    other.body.applyLinearImpulse(
      worldManifold.normal
        ..multiply(
          Vector2.all(other.body.mass * _strength),
        ),
    );
  }
}
