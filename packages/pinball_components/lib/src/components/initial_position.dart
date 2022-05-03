import 'package:flame_forge2d/flame_forge2d.dart';

/// Forces a given [BodyComponent] to position their [body] to an
/// [initialPosition].
///
/// Note: If the [initialPosition] is set after the [BodyComponent] has been
/// loaded it will have no effect; defaulting to [Vector2.zero].
mixin InitialPosition on BodyComponent {
  final Vector2 _initialPosition = Vector2.zero();

  set initialPosition(Vector2 value) {
    assert(
      !isLoaded,
      'Cannot set initialPosition after component has already loaded.',
    );
    if (value == initialPosition) return;

    _initialPosition.setFrom(value);
  }

  /// The initial position of the [body].
  Vector2 get initialPosition => _initialPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alestiago): Investiagate why body.position.setFrom(initialPosition)
    // works for some components and not others.
    assert(
      body.position == initialPosition,
      'Body position does not match initialPosition.',
    );
  }
}
