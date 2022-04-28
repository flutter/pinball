import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template bumping_behavior}
/// Makes any [BodyComponent] that contacts with [parent] bounce off.
/// {@endtemplate}
class BumpingBehavior extends ContactBehavior {
  /// {@macro bumping_behavior}
  BumpingBehavior({required double strength}) : _strength = strength;

  /// Determines how strong the bump is.
  final double _strength;

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);
    if (other is! BodyComponent) return;

    other.body.applyLinearImpulse(
      contact.manifold.localPoint
        ..normalize()
        ..multiply(Vector2.all(other.body.mass * _strength)),
    );
  }
}
