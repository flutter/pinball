import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template bumping_behavior}
/// Makes any [BodyComponent] that contacts with [parent] to bounce off.
/// {@endtemplate}
class BumpingBehavior extends ContactBehavior {
  /// {@macro bumping_behavior}
  BumpingBehavior({required this.strength});

  /// Determines how strong the bump is.
  double strength;

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);
    if (other is! BodyComponent) return;

    other.body.applyLinearImpulse(
      contact.manifold.localPoint
        ..normalize()
        ..multiply(Vector2.all(other.body.mass * strength)),
    );
  }
}
