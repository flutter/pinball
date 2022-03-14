import 'package:flame_forge2d/flame_forge2d.dart';

mixin InitialPosition on BodyComponent {
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
