import 'package:flame_forge2d/flame_forge2d.dart';

/// Forces a given [BodyComponent] to position their [body] to an
/// [initialPosition].
mixin InitialPosition<T extends Forge2DGame> on BodyComponent<T> {
  /// The initial position of the [body].
  late final Vector2 initialPosition;

  @override
  void onMount() {
    super.onMount();
    assert(
      body.position == initialPosition,
      'Body position is not equal to initial position.',
    );
  }
}
